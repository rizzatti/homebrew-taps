require 'formula'

class Rabbitmqc < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/tarball/0.2'
  version '0.2'
  sha1 '37029aa53d542ddc2a529fbb7c1d2edb7ad007c0'

  depends_on 'cmake'

  def install
    system "cmake", ".", '-DFETCH_CODEGEN_FROM_GIT=1', *std_cmake_args
    system "make"
    system "make install"
  end
end
