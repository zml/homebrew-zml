class Llmd < Formula
  desc "ZML's high-performance, OpenAI-compatible LLM server"
  homepage "https://zml.ai"
  url "https://mirror.zml.ai/llmd/llmd/llmd-macos-20261009.0-arm64.tar.zst"
  version "20261009.0"
  sha256 "e385da08dce0cfdf6a88761b7cedf68ba5d931d6dc62562db657fe78b264ffd4"

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
