class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-8.0.tar.xz"
  sha256 "690eefe28633466cfd1ab9d85ebfa9376f6b622deec6bfee5091ac9737cd1989"

  bottle do
    revision 1
    sha256 "ec432b0c8e3462f1e8c66b3042ac55f64fa0f050797a6a21914766dd649c15b0" => :el_capitan
    sha256 "7c904d263248a34400e7014542b2fc966b375959a8ed86cd48619c4aaa4b4534" => :yosemite
    sha256 "95fd865d58978d8f06e76e8ed49893b45f37b69656d831d6c66cfd28a0b6495c" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"
  option :universal

  depends_on "pkg-config" => :build

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libtool" => :run
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "libpcap"

  depends_on :x11 => :optional
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "d-bus" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-neon-opt
    ]

    args << "--disable-nls" if build.without? "nls"

    if build.universal?
      args << "--enable-mac-universal"
      ENV.universal_binary
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"pulseaudio", "--dump-modules"
  end
end

__END__
