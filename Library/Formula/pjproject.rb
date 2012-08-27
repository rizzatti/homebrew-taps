require 'formula'

class Pjproject < Formula
  homepage 'http://www.pjsip.org'
  url 'http://www.pjsip.org/release/2.0.1/pjproject-2.0.1.tar.bz2'
  version '2.0.1'
  sha1 '67f24ae4ec781e20fe6111b64e08ef0e21f300b3'

  fails_with :clang do
    build 421
  end

  def install
    ENV.j1
    system "./configure", "--disable-video", "--disable-ssl", "--prefix=#{prefix}"
    usermak = <<-EOF
export AR = ar rv
export LD = ld
export RANLIB = ranlib
EOF
    File.open('user.mak', 'w') do |file|
      file.write usermak
    end
    system "make dep"
    system "make"
    system "make install"
  end
end
