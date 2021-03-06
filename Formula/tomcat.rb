class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz"
    sha256 "d72234baa373234aa9ed78e8331ac1ce47d2e07a262dafce35d17389825bc8b7"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9-fulldocs.tar.gz"
      version "8.5.9"
      sha256 "35d1077a1aa8361afa484b1eca1a48d4037bd7a112f38098ccd406107c75dfe7"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M15/bin/apache-tomcat-9.0.0.M15.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M15/bin/apache-tomcat-9.0.0.M15.tar.gz"
    version "9.0.0.M15"
    sha256 "6290995ef5b24b6e9b6477f24cb419b8d309285fcb8d3807baf4360177c1ebea"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M15/bin/apache-tomcat-9.0.0.M15-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M15/bin/apache-tomcat-9.0.0.M15-fulldocs.tar.gz"
      version "9.0.0.M15"
      sha256 "3a4428711014aa8c69cb5d368c613ce85ab771481790948844e172664b87a5a7"
    end
  end

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

  conflicts_with "tomcat@6", :because => "Differing versions of same formula"
  conflicts_with "tomcat@7", :because => "Differing versions of same formula"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    File.exist? testpath/"logs/catalina.out"
  end
end
