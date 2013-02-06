require 'formula'

class Qt5 < Formula
  homepage 'http://qt-project.org/'
  url 'http://releases.qt-project.org/qt5/5.0.1/single/qt-everywhere-opensource-src-5.0.1.tar.gz'
  sha1 'fda04435b1d4069dc189ab4d22ed7a36fe6fa3e9'

  head 'git://gitorious.org/qt/qt5.git', :branch => 'master'

  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-examples', 'Enable Qt examples'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'with-mysql', 'Enable MySQL plugin'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on :libpng

  depends_on "d-bus" if build.include? 'with-qtdbus'
  depends_on "mysql" if build.include? 'with-mysql'

  def patches
    # commit 655ba5755696df8e2594bca9f7696ab621f5afc3
    # Author: Gabriel de Dietrich <gabriel.dedietrich@digia.com>
    # Date:   Tue Feb 5 13:39:33 2013 +0100
    #
    #     Cocoa QPA: Fix compilation error
    #
    #     The error appeared with latest clang as of Feb. 5, 2013.
    #
    #     Apple LLVM version 4.2 (clang-425.0.24) (based on LLVM 3.2svn)
    #     Target: x86_64-apple-darwin12.2.0
    #
    #     Change-Id: I8df8cccc941ac03a7a997bdd5afe095b7b6f65d3
    #     Reviewed-by: Frederik Gladhorn <frederik.gladhorn@digia.com>
    DATA
  end

  def install
    args = ["-prefix", prefix,
            "-system-libpng",
            "-system-zlib",
            "-confirm-license",
            "-opensource"]

    args << "-L#{MacOS::X11.prefix}/lib" << "-I#{MacOS::X11.prefix}/include" if MacOS::X11.installed?

    args << "-plugin-sql-mysql" if build.include? 'with-mysql'

    if build.include? 'with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
    end

    unless build.include? 'with-examples'
      args << "-nomake" << "examples"
    end

    if build.include? 'with-debug-and-release'
      args << "-debug-and-release"
      # Debug symbols need to find the source so build in the prefix
      mv "../qt-everywhere-opensource-src-#{version}", "#{prefix}/src"
      cd "#{prefix}/src"
    else
      args << "-release"
    end

    args << '-developer-build' if build.include? 'developer'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    # VirtualBox is an example of where this is needed
    # See: https://github.com/mxcl/homebrew/issues/issue/745
    cd prefix do
      ln_s lib, prefix + "Frameworks"
    end

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob(lib + '*.framework/Headers').each do |path|
      framework_name = File.basename(File.dirname(path), '.framework')
      ln_s path.realpath, include+framework_name
    end

    Pathname.glob(bin + '*.app').each do |path|
      mv path, prefix
    end
  end

  def test
    system "#{bin}/qmake", "--version"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end

__END__
diff --git a/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h b/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
index 3b5be0a..324a43c 100644
--- a/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
+++ b/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
@@ -49,7 +49,8 @@
 
 #include "qcocoaglcontext.h"
 #include "qnsview.h"
-class QT_PREPEND_NAMESPACE(QCocoaWindow);
+
+QT_FORWARD_DECLARE_CLASS(QCocoaWindow)
 
 @interface QNSWindow : NSWindow {
     @public QCocoaWindow *m_cocoaPlatformWindow;

