require 'formula'

class Rabbitmqc < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/tarball/0.2'
  version '0.2'
  sha1 '37029aa53d542ddc2a529fbb7c1d2edb7ad007c0'
  head 'https://github.com/alanxz/rabbitmq-c.git'

  depends_on 'cmake'

  def install
    std_cmake_args << '-DFETCH_CODEGEN_FROM_GIT=1' unless build.head?
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end
end
