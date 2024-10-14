from tempfile import NamedTemporaryFile

from openai_rt_client.utils.log import Logger, DEBUG, INFO


@always_inline
fn _assert_error(lhs: String, rhs: String, msg: String) -> String:
    var err = (
        "`left == right` comparison failed:\n  left: " + lhs + "\n  right: " + rhs
    )
    if msg:
        err += "\n  reason: " + msg
    return "AssertionError: " + str(err)


struct PrintChecker:
    var tmp: NamedTemporaryFile
    var cursor: UInt64

    @always_inline
    fn __init__(inout self) raises:
        self.tmp = NamedTemporaryFile("rw")
        self.cursor = 0

    fn __enter__(owned self) -> Self:
        return self^

    fn __moveinit__(inout self, owned existing: Self):
        self.tmp = existing.tmp^
        self.cursor = existing.cursor

    fn stream(self) -> FileDescriptor:
        return self.tmp._file_handle._get_raw_fd()

    fn check_line(inout self, expected: String, msg: String = "") raises:
        print(end="", file=self.stream(), flush=True)
        _ = self.tmp.seek(self.cursor)
        var result = self.tmp.read()[:-1]
        if result != expected:
            raise _assert_error(result, expected, msg)
        self.cursor += len(result) + 1


fn test_info_log() raises:
    with PrintChecker() as checker:
        var logger = Logger(file=checker.stream(), level=INFO)
        logger.info('This is an info message')

        checker.check_line('[INFO] This is an info message')


fn test_debug_log() raises:
    with PrintChecker() as checker:
        var logger = Logger(file=checker.stream(), level=DEBUG)
        logger.debug('This is a debug message')

        checker.check_line('[DEBUG] This is a debug message')


fn test_warning_log() raises:
    with PrintChecker() as checker:
        var logger = Logger(file=checker.stream(), level=INFO)
        logger.warn('This is a warn message')

        checker.check_line('[WARN] This is a warn message')


fn test_error_log() raises:
    with PrintChecker() as checker:
        var logger = Logger(file=checker.stream(), level=INFO)
        logger.error('This is an error message')

        checker.check_line('[ERROR] This is an error message')


fn test_log_levels() raises:
    with PrintChecker() as checker:
        var logger = Logger(file=checker.stream(), level=INFO)
        logger.debug('This should not be logged')
        logger.info('This should be logged')

        checker.check_line('[INFO] This should be logged')


fn run() raises:
    test_info_log()
    test_debug_log()
    test_warning_log()
    test_error_log()
    test_log_levels()

