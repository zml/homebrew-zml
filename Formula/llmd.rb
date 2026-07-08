class Llmd < Formula
  desc "ZML's high-performance, OpenAI-compatible LLM server"
  homepage "https://zml.ai"
  url "https://mirror.zml.ai/llmd/llmd-macos-20260708-arm64.tar.zst"
  version "0.1.0"
  sha256 "2c0fc29c344759978a19d23c819ea3bfe0949e2bdec7d1fd6961444e36eca1e7"

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

      Load a model directly from the Hugging Face Hub and serve an OpenAI-compatible API:
        llmd --model=hf://Qwen/Qwen3.6-27B

      Or point it at a local model repository:
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
