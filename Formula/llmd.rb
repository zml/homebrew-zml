class Llmd < Formula
  desc "ZML's high-performance, OpenAI-compatible LLM server"
  homepage "https://zml.ai"
  url "https://mirror.zml.ai/llmd/llmd/llmd-macos-20261023.0-arm64.tar.zst"
  version "20261023.0"
  sha256 "61e7b5a2eed1e804ef1e975407eff46d84c9e6491d19efd6fab664b854a4e492"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    libexec.install "llmd", "llmd.runfiles"
    (bin/"llmd").write_env_script libexec/"llmd", RUNFILES_DIR: libexec/"llmd.runfiles"
  end

  def caveats
    <<~'EOS'
      llmd runs on the Apple Silicon GPU via Metal.

      Start the server with a local model repository:
        llmd --model=/path/to/model --model-name=local-model --token-batch-size=512 --max-context-len=2048 --batch-size=1

      Then send a request to the OpenAI-compatible endpoint:
        curl http://localhost:8000/v1/chat/completions \
          -H 'Content-Type: application/json' \
          -d '{"model": "local-model",
               "messages": [{"role": "user", "content": "Hello!"}]}'

      To enable speculative decoding, pass:
        --speculative-drafter-model=/path/to/drafter-model
      The drafter must be compatible with the target model.
    EOS
  end

  test do
    assert_match "Usage: llmd", shell_output("#{bin}/llmd --help 2>&1")
  end
end
