"""
UVM-style singleton Reporter class with asyncio support.

Features:
- Leveled logging (LOW/MEDIUM/HIGH/ERROR/FATAL)
- Error tracking and fatal error handling
- Asyncio integration: simulation time, graceful task cancellation
- Report phase callback for final statistics
"""

import sys
import asyncio
from enum import IntEnum
from datetime import datetime
from typing import Optional, TextIO, Callable


class ReportLevel(IntEnum):
    FATAL = -2
    ERROR = -1
    NONE = 0
    LOW = 100
    MEDIUM = 200
    HIGH = 300
    FULL = 400
    DEBUG = 500


class Reporter:
    """UVM-style singleton Reporter with asyncio support.
    
    Features:
    - Singleton pattern: global unique instance
    - Leveled reporting: LOW/MEDIUM/HIGH/ERROR/FATAL
    - Message filtering: based on verbosity threshold
    - Formatted output: timestamp, caller, level tags
    - Error tracking: automatic error counting
    - Fatal handling: terminate simulation
    - Asyncio integration: sim time, graceful task cancellation
    
    Example:
        reporter = Reporter.get_instance(verbosity=ReportLevel.MEDIUM)
        reporter.report_msg("my_component", "Starting test", ReportLevel.HIGH)
        reporter.report_error("my_driver", "Data mismatch detected")
        await reporter.report_fatal_async("my_env", "Critical failure")
    """
    
    _instance: Optional['Reporter'] = None
    _initialized: bool = False
    
    def __new__(cls, *args, **kwargs):
        """Singleton pattern: ensure only one instance."""
        if cls._instance is None:
            cls._instance = super(Reporter, cls).__new__(cls)
        return cls._instance
    
    def __init__(self, 
                 verbosity: ReportLevel = ReportLevel.MEDIUM,
                 output_file: Optional[TextIO] = None,
                 enable_timestamp: bool = True,
                 enable_color: bool = False,
                 use_sim_time: bool = True,
                 log_file_path: Optional[str] = None,
                 dut = None):
        """Initialize Reporter (only effective on first call).
        
        Args:
            verbosity: Report level threshold, filters lower priority messages
            output_file: Output file object, defaults to stdout
            enable_timestamp: Enable timestamp prefix
            enable_color: Enable ANSI color codes
            use_sim_time: Use simulation time (True) or system time (False)
            log_file_path: Path to log file. If provided, logs will be written to this file in addition to output_file.
            dut: DUT object for accessing simulation time
        """
        # Singleton: avoid re-initialization
        if Reporter._initialized:
            return
        
        self.verbosity = verbosity
        self.output_file = output_file if output_file else sys.stdout
        self.enable_timestamp = enable_timestamp
        self.enable_color = enable_color
        self.use_sim_time = use_sim_time
        self.dut = dut
        
        # Log file handling
        self.log_file = None
        if log_file_path:
            try:
                self.log_file = open(log_file_path, 'w')
                # Debug print
                # print(f"DEBUG: Opened log file {log_file_path}", file=sys.__stdout__)
            except IOError as e:
                print(f"Warning: Could not open log file {log_file_path}: {e}", file=sys.stderr)
        
        # Asyncio related
        self._loop: Optional[asyncio.AbstractEventLoop] = None
        self._report_phase_callback: Optional[Callable] = None
        
        # Statistics
        self.error_count = 0
        self.warning_count = 0
        self.message_count = 0
        
        # ANSI color codes
        self._colors = {
            ReportLevel.LOW: '\033[90m',
            ReportLevel.MEDIUM: '\033[37m',
            ReportLevel.HIGH: '\033[94m',
            ReportLevel.FULL: '\033[37m',
            ReportLevel.DEBUG: '\033[32m',
            ReportLevel.ERROR: '\033[91m',
            ReportLevel.FATAL: '\033[95m',
            ReportLevel.NONE: '',
        }
        self._color_reset = '\033[0m'
        
        Reporter._initialized = True
    
    @classmethod
    def get_instance(cls, 
                     verbosity: ReportLevel = ReportLevel.MEDIUM,
                     output_file: Optional[TextIO] = None,
                     enable_timestamp: bool = True,
                     enable_color: bool = False,
                     use_sim_time: bool = True,
                     log_file_path: Optional[str] = None,
                     dut = None) -> 'Reporter':
        """Get Reporter singleton instance (recommended method).
        
        Args:
            verbosity: Report level threshold (only on first creation)
            output_file: Output file object (only on first creation)
            enable_timestamp: Enable timestamp (only on first creation)
            enable_color: Enable color (only on first creation)
            use_sim_time: Use simulation time (only on first creation)
            log_file_path: Path to log file (only on first creation)
            dut: DUT object (only on first creation)
            
        Returns:
            Reporter singleton instance
        """
        if cls._instance is None:
            cls._instance = cls(verbosity, output_file, enable_timestamp, enable_color,
                               use_sim_time, log_file_path, dut)
        return cls._instance
    
    @classmethod
    def reset_instance(cls):
        """Reset singleton instance (mainly for testing)."""
        cls._instance = None
        cls._initialized = False
    
    def set_dut(self, dut):
        """Set DUT object for accessing simulation time.
        
        Args:
            dut: DUT object
        """
        self.dut = dut
    
    def set_verbosity(self, verbosity: ReportLevel):
        """Dynamically set report level threshold.
        
        Args:
            verbosity: New report level threshold
        """
        self.verbosity = verbosity
    
    def set_event_loop(self, loop: asyncio.AbstractEventLoop):
        """Set asyncio event loop.
        
        Args:
            loop: Asyncio event loop object
        """
        self._loop = loop
        
    def get_timestamp(self) -> int:
        """Get current timestamp string."""
        return ((self.dut.xclock.clk)*2+1)

    def set_report_phase_callback(self, callback: Callable):
        """Set report phase callback function.
        
        On fatal error, all tasks are cancelled first, then this callback
        is invoked to enter the report phase.
        
        Args:
            callback: Callback function or coroutine for report phase operations
        """
        self._report_phase_callback = callback
    
    def _print_timestamp(self) -> str:
        """Get current timestamp string.
        
        Returns simulation time (asyncio loop time) or system time.
        """
        return f"Cycle: {self.dut.xclock.clk} Time:{(self.dut.xclock.clk)*2+1}"
    
    def _colorize(self, text: str, level: ReportLevel) -> str:
        """Add color codes to text.
        
        Args:
            text: Text to colorize
            level: Report level, determines color
            
        Returns:
            Text with ANSI color codes
        """
        if not self.enable_color:
            return text
        color = self._colors.get(level, '')
        return f"{color}{text}{self._color_reset}"
    
    def _format_message(self, 
                       caller: str, 
                       message: str, 
                       level: ReportLevel) -> str:
        """Format report message.
        
        Args:
            caller: Caller name
            message: Message content
            level: Report level
            
        Returns:
            Formatted message string
        """
        level_tags = {
            ReportLevel.LOW: "DBG",
            ReportLevel.MEDIUM: "INFO",
            ReportLevel.HIGH: "INFO",
            ReportLevel.FULL: "INFO",
            ReportLevel.DEBUG: "DBG",
            ReportLevel.ERROR: "ERROR",
            ReportLevel.FATAL: "FATAL",
            ReportLevel.NONE: "NONE",
        }
        level_tag = level_tags.get(level, "INFO")
        
        # Build message
        parts = []
        
        # Timestamp
        if self.enable_timestamp:
            timestamp = self._print_timestamp()
            parts.append(f"[{timestamp}]")
        
        # Level tag
        colored_tag = self._colorize(f"[{level_tag}]", level)
        parts.append(colored_tag)
        
        # Caller
        parts.append(f"[{caller}]")
        
        # Message
        parts.append(message)
        
        return " ".join(parts)
    
    def _report(self, 
               caller: str, 
               message: str, 
               level: ReportLevel) -> None:
        """Low-level report function (internal use).
        
        Args:
            caller: Caller name
            message: Message content
            level: Report level
        """
        # Filter messages above verbosity; errors/fatal always printed due to negative level
        if level > self.verbosity:
            return
        
        # Format and output message
        formatted_msg = self._format_message(caller, message, level)
        print(formatted_msg, file=self.output_file)
        
        # Write to log file if enabled (strip colors)
        if self.log_file:
            import re
            ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
            plain_msg = ansi_escape.sub('', formatted_msg)
            print(plain_msg, file=self.log_file)
            self.log_file.flush()
        
        # Update statistics
        self.message_count += 1
        if level == ReportLevel.ERROR:
            self.error_count += 1
    
    def report_msg(self, 
                   caller: str, 
                   message: str, 
                   level: ReportLevel = ReportLevel.MEDIUM) -> None:
        """Report general message.
        
        Args:
            caller: Caller name (e.g., "vfadd_xaction", "my_driver")
            message: Message content to report
            level: Message level (LOW/MEDIUM/HIGH), defaults to MEDIUM
            
        Example:
            reporter.report_msg("my_driver", "Transaction sent", ReportLevel.HIGH)
            reporter.report_msg("my_monitor", "Received response", ReportLevel.LOW)
        """
        self._report(caller, message, level)
    
    def report_error(self, 
                    caller: str, 
                    message: str) -> None:
        """Report error message (level fixed at ERROR).
        
        Error messages are not filtered and automatically increment error counter.
        
        Args:
            caller: Caller name
            message: Error description
            
        Example:
            reporter.report_error("my_scoreboard", "Data mismatch: expected 0x123, got 0x456")
        """
        self._report(caller, message, ReportLevel.ERROR)
    
    def report_fatal(self, 
                    caller: str, 
                    message: str,
                    exit_code: int = 1) -> None:
        """Report fatal error and terminate simulation (sync version).
        
        Immediately prints error message and statistics, then calls sys.exit().
        
        Args:
            caller: Caller name
            message: Fatal error description
            exit_code: Exit code, defaults to 1
            
        Example:
            reporter.report_fatal("my_env", "Critical hardware error detected")
        
        Note: This method does not return, program will terminate!
        Warning: In asyncio environments, use report_fatal_async() for graceful task cancellation.
        """
        # Report fatal error
        self._report(caller, message, ReportLevel.FATAL)
        
        # Print summary
        self.print_summary()
        
        # Terminate simulation
        sys.exit(exit_code)
    
    async def report_fatal_async(self,
                                 caller: str,
                                 message: str,
                                 exit_code: int = 1) -> None:
        """Report fatal error and gracefully cancel all asyncio tasks (async version).
        
        This method will:
        1. Report fatal error message
        2. Cancel all running asyncio tasks
        3. Call report phase callback (if set)
        4. Print statistics summary
        5. Exit program
        
        Args:
            caller: Caller name
            message: Fatal error description
            exit_code: Exit code, defaults to 1
            
        Example:
            await reporter.report_fatal_async("my_env", "Critical failure")
        
        Note: This method will eventually call sys.exit() to terminate program!
        """
        # Report fatal error
        self._report(caller, message, ReportLevel.FATAL)
        
        # Get current event loop
        loop = self._loop if self._loop else asyncio.get_event_loop()
        
        # Get all tasks (exclude current task)
        current_task = asyncio.current_task(loop)
        all_tasks = asyncio.all_tasks(loop)
        other_tasks = [t for t in all_tasks if t is not current_task and not t.done()]
        
        if other_tasks:
            self.report_msg("Reporter", 
                          f"Cancelling {len(other_tasks)} running tasks...",
                          ReportLevel.HIGH)
            
            # Cancel all other tasks
            for task in other_tasks:
                task.cancel()
            
            # Wait for all tasks to complete cancellation
            await asyncio.gather(*other_tasks, return_exceptions=True)
            
            self.report_msg("Reporter",
                          "All tasks cancelled",
                          ReportLevel.HIGH)
        
        # Enter report phase
        if self._report_phase_callback:
            self.report_msg("Reporter",
                          "Entering report phase...",
                          ReportLevel.HIGH)
            
            if asyncio.iscoroutinefunction(self._report_phase_callback):
                await self._report_phase_callback()
            else:
                self._report_phase_callback()
        
        # Print summary
        self.print_summary()
        
        # Terminate simulation
        sys.exit(exit_code)
    
    def report_warning(self, 
                      caller: str, 
                      message: str) -> None:
        """Report warning message (uses HIGH level).
        
        Args:
            caller: Caller name
            message: Warning description
            
        Example:
            reporter.report_warning("my_driver", "Timeout occurred, retrying...")
        """
        self.warning_count += 1
        colored_message = self._colorize(f"WARNING: {message}", ReportLevel.HIGH)
        self._report(caller, colored_message, ReportLevel.HIGH)
    
    def print_summary(self) -> None:
        """Print statistics summary."""
        separator = "=" * 60
        
        # Helper to print to both outputs
        def _print_both(text):
            print(text, file=self.output_file)
            if self.log_file:
                print(text, file=self.log_file)
        
        _print_both(f"\n{separator}")
        _print_both("Reporter Summary")
        _print_both(separator)
        _print_both(f"Total Messages: {self.message_count}")
        _print_both(f"Warnings:       {self.warning_count}")
        _print_both(f"Errors:         {self.error_count}")
        _print_both(separator)
        
        if self.log_file:
            self.log_file.flush()
    
    def get_error_count(self) -> int:
        """Get error count."""
        return self.error_count
    
    def get_warning_count(self) -> int:
        """Get warning count."""
        return self.warning_count
    
    def has_errors(self) -> bool:
        """Check if any errors occurred."""
        return self.error_count > 0
    
    def clear_counters(self) -> None:
        """Clear all counters (for test scenario switching)."""
        self.error_count = 0
        self.warning_count = 0
        self.message_count = 0
    
    def report_pre(self, case_name: str, seed: int) -> None:
        """Report test case start information.
        
        Args:
            case_name: Name of the test case
            seed: Random seed used
        """
        start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        separator = "=" * 60
        
        # Use a special formatting for PRE report (Raw output without prefixes)
        lines = [
            separator,
            f"TEST CASE START",
            f"Name : {case_name}",
            f"Seed : {seed}",
            f"Time : {start_time}",
            f"Report Level : {self.verbosity.name}",
            separator
        ]
        
        for line in lines:
            print(line, file=self.output_file)
            if self.log_file:
                print(line, file=self.log_file)
        
        if self.log_file:
            self.log_file.flush()

    def report_post(self) -> None:
        """Report test case finish information (Placeholder)."""
        pass


# Convenience global access function
def get_reporter(verbosity: ReportLevel = ReportLevel.MEDIUM,
                use_sim_time: bool = True,
                log_file_path: Optional[str] = None,
                dut = None) -> Reporter:
    """Get global Reporter instance (convenience function).
    
    Args:
        verbosity: Report level threshold (only on first call)
        use_sim_time: Use simulation time (only on first call)
        log_file_path: Path to log file (only on first call)
        dut: DUT object (only on first call)
        
    Returns:
        Reporter singleton instance
    """
    return Reporter.get_instance(verbosity=verbosity, use_sim_time=use_sim_time, log_file_path=log_file_path, dut=dut)
