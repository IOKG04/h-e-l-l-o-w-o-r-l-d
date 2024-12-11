import os
from setuptools.command.build_ext import build_ext
from setuptools import setup, Extension

class ZigBuilder(build_ext):
    def build_extension(self, ext):
        prefix = "/".join(self.get_ext_fullpath(ext.name).split("/")[:-1])

        mode = "off" if self.debug else "safe"
        self.spawn([
            "zig",
            "build",
            "--release=" + mode,
            "-Dname=" + ext.name,
            "--prefix",
            prefix
        ])

        self.spawn([
            "mv",
            prefix + "/lib/libtools.so",
            self.get_ext_fullpath(ext.name)
        ])


tools = Extension("tools", sources=[])

setup(
    name="tools",
    version="1.2.3",
    description="Tools to build further parts of h-w",
    ext_modules=[tools],
    cmdclass={"build_ext": ZigBuilder}
)
