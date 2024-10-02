from tests import test_api
from tests import test_audio
from tests import test_client
from tests import test_event_handlers


def main():
    test_api.run()
    test_audio.run()
    test_client.run()
    test_event_handlers.run()
