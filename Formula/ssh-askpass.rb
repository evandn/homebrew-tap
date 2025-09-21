class SshAskpass < Formula
  desc "A minimal ssh-askpass for macOS"
  homepage "https://github.com/evandn/ssh-askpass"
  url "https://github.com/evandn/ssh-askpass/archive/v1.0.0.tar.gz"
  sha256 "a0cfa796aa5a2eaff66a5f4fe4d6781e03b28fdde5a1614a35dec9ab54050b07"
  license "Apache-2.0"

  depends_on "openssh"
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
