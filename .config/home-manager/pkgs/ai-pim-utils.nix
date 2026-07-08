# ai-pim-utils — NVIDIA's AI-agent CLI suite for Microsoft 365 + enterprise systems.
#
# There is no upstream Nix packaging. Upstream ships prebuilt, release-signed
# binaries (Homebrew cask, a curl installer, and GitLab generic-package archives).
# We repackage the official Linux/amd64 release archive rather than building from
# source, because the OAuth client IDs / telemetry endpoint are baked into the
# release binaries at CI build time via ldflags using secrets we don't hold.
# Building from source would produce binaries that can't authenticate against the
# shared NVIDIA app registration.
#
# To update: bump `version`, set `hash` to lib.fakeHash, rebuild, paste the
# correct hash from the error. Or run:
#   nix store prefetch-file --json \
#     "https://gitlab-master.nvidia.com/api/v4/projects/206465/packages/generic/ai-pim-utils/<VER>/ai-pim-utils_<VER>_linux_amd64.tar.gz"
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  pcsclite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ai-pim-utils";
  version = "0.101.5";

  src = fetchurl {
    url = "https://gitlab-master.nvidia.com/api/v4/projects/206465/packages/generic/ai-pim-utils/${finalAttrs.version}/ai-pim-utils_${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-qc0g1IbfsyN/cJ8Pw91+34p5zkzI3lq7qANhltEcVxk=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  # CGO-enabled glibc binaries. stdenv.cc.cc.lib provides libgcc_s; pcsclite is
  # dlopen'd at runtime only when using the YubiKey presence backend — adding it
  # to buildInputs puts it on the runpath so that dlopen resolves it.
  buildInputs = [
    stdenv.cc.cc.lib
    pcsclite
  ];

  # The release tarball is wrapped in a single ai-pim-utils_<ver>_linux_amd64/
  # directory; stdenv's unpackPhase descends into it automatically. Every CLI is
  # named "<name>-cli"; the dir also carries README.md / docs/ / install.sh which
  # we drop.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    for f in *-cli; do
      install -Dm755 "$f" "$out/bin/$f"
    done
    runHook postInstall
  '';

  meta = {
    description = "AI-agent CLI suite for Microsoft 365 and NVIDIA enterprise systems (outlook-cli, calendar-cli, jira-cli, …)";
    homepage = "https://gitlab-master.nvidia.com/ai-cli/ai-pim-utils";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    # ~30 binaries; outlook-cli is the canonical entrypoint (auth, skills sync).
    mainProgram = "outlook-cli";
  };
})
