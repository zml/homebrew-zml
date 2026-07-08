class Llmd < Formula
  desc "ZML's high-performance, OpenAI-compatible LLM server"
  homepage "https://zml.ai"
  url "https://mirror.zml.ai/llmd/llmd-macos-20260708.1-arm64.tar.zst"
  version "0.1.1"
  sha256 "32b3e4a94ed103c05759d5612781b45925d3a7fb9fb784bc7bb0d0d3f9983f8b"

  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    libexec.install "llmd", "llmd.runfiles"
    (bin/"llmd").write_env_script libexec/"llmd", RUNFILES_DIR: libexec/"llmd.runfiles"
  end

  def caveats
    <<~'EOS'
      llmd runs on the Apple Silicon GPU via Metal.
      Supported model families: Qwen3.5, Qwen3.6, and Gemma.
      DFlash is supported on Gemma with `--dflash-model=/path/to/dflash-model`

      Point it at a local model repository and serve an OpenAI-compatible API:
        llmd --model=/path/to/model --token-batch-size=512 --max-context-len=2048 --batch-size=1

      Then send a request to the OpenAI-compatible endpoint:
        curl http://localhost:8000/v1/chat/completions \
          -H 'Content-Type: application/json' \
          -d '{"model": "google/gemma-4-12b-it",
               "messages": [{"role": "user", "content": "Hello!"}]}'
    EOS
  end

  test do
    assert_match "Usage: llmd", shell_output("#{bin}/llmd --help 2>&1")
  end
end
