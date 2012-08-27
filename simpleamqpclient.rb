require 'formula'

class Simpleamqpclient < Formula
  homepage 'https://github.com/alanxz/SimpleAmqpClient'
  url 'https://github.com/alanxz/SimpleAmqpClient/tarball/v2.0-beta'
  version '2.0-beta'
  sha1 'f2c7255b01ce6274e7a467591c5765ece2c011a8'
  head 'https://github.com/alanxz/SimpleAmqpClient.git'

  depends_on 'cmake' => :build
  depends_on 'rabbitmq-c'
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end
end
