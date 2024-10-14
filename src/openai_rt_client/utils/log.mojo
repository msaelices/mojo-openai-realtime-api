from collections import Dict

alias DEBUG = 0
alias INFO = 1
alias WARN = 2
alias ERROR = 3


@value
struct Logger:
    var level: Int

    fn __init__(inout self, level: Int = INFO):
        self.level = level

    fn set_log_level(inout self, level: Int):
        self.level = level

    fn debug(self, msg: String):
        self._log(DEBUG, msg)

    fn info(self, msg: String):
        self._log(INFO, msg)

    fn warn(self, msg: String):
        self._log(WARN, msg)

    fn error(self, msg: String):
        self._log(ERROR, msg)

    fn _log(self, level: Int, msg: String):
        if level >= self.level:
            print('[' + _level_to_str(level) + ']' + msg)


@always_inline
fn _level_to_str(level: Int) -> String:
    # TODO: Use a match statement when it's available
    if level == DEBUG:
        return 'DEBUG'
    elif level == INFO:
        return 'INFO'
    elif level == WARN:
        return 'WARN'
    elif level == ERROR:
        return 'ERROR'
    else:
        return 'UNKNOWN'
