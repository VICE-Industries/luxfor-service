from fastapi import FastAPI
import usb.core
import usb.util
import uvicorn

description = """
API drive Luxafor devices 🚀
"""

app = FastAPI(
    title="Luxafor API service",
    description=description,
    version="1.0.0",
    contact={
        "name": "23 Technologies GmbH",
        "url": "https://github.com/VICE-Industries/fastapi-luxafor",
        "email": "info@23technologies.cloud",
    },
)

# {{{
#
# SPDX-License-Identifier: CC0-1.0
#
# Based on https://github.com/vmitchell85/luxafor-python/blob/master/luxafor-linux.py

DEVICES = []
DEVICE = 0


def setup_devices():
    global DEVICES

    for flag in usb.core.find(find_all=True, idProduct=0xF372):
        DEVICES.append(flag)

    # Device found?
    if len(DEVICES) < 1:
        raise ValueError("Device(s) not found")

    # Linux kernel sets up a device driver for USB device, which you have to detach.
    # Otherwise trying to interact with the device gives a 'Resource Busy' error.
    for flag in DEVICES:
        try:
            flag.detach_kernel_driver(0)
        except Exception:
            pass

        flag.set_configuration()


def write_value(values):
    global DEVICE

    if DEVICE > 0:
        do_write_value(DEVICES[DEVICE - 1], values)
        return

    for flag in DEVICES:
        do_write_value(flag, values)


def do_write_value(target, values):
    # Run it twice to ensure it works.
    target.write(1, values)
    target.write(1, values)


# }}}


@app.post("/color")
async def color(red: int, green: int, blue: int):
    write_value([1, 255, red, green, blue, 0, 0])
    return {"result": "ok"}


@app.on_event("startup")
def on_startup():
    setup_devices()


def main():
    config = uvicorn.Config(
        "main:app",
        host="0.0.0.0",
        port=8080,
        log_level="debug",
        proxy_headers=True,
        forwarded_allow_ips=["*"],
    )
    server = uvicorn.Server(config)
    server.run()


if __name__ == "__main__":
    main()
