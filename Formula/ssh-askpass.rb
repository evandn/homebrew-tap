class SshAskpass < Formula
  desc "A minimal ssh-askpass for macOS"
  homepage "https://github.com/evandn/ssh-askpass"
  url "https://github.com/evandn/ssh-askpass/archive/v1.0.1.tar.gz"
  sha256 "ac3483268fa36ec554948444a47bb075a71b40de534224faa527888e1fac5a7d"
  license "Apache-2.0"

  depends_on "pinentry-mac"

  def install
    bin.install name
  end

  service do
    run ["sh", "-c", <<~SH]
      launchctl setenv SSH_ASKPASS "$SSH_ASKPASS"
      launchctl setenv SSH_ASKPASS_REQUIRE "$SSH_ASKPASS_REQUIRE"
      pkill -x ssh-agent
      rm -f "$SSH_AUTH_SOCK" && ssh-agent -Da "$SSH_AUTH_SOCK"
    SH
    keep_alive true
    environment_variables PATH: std_service_path_env,
                          SSH_ASKPASS: opt_bin/f.name,
                          SSH_ASKPASS_REQUIRE: "force"
  end

  test do
    system "true"
  end
end
