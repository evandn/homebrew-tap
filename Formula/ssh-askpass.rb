class SshAskpass < Formula
  desc "A minimal ssh-askpass for macOS"
  homepage "https://github.com/evandn/ssh-askpass"
  url "https://github.com/evandn/ssh-askpass/archive/v1.0.0.tar.gz"
  sha256 "95c26004e0c747b530bd416335a09a9db92df2fb4e5fde9154f3c2e468187d11"
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
