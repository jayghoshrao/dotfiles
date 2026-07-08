# lathe — Go CLI that generates source-backed, hands-on tutorials via LLMs.
# https://github.com/devenjarvis/lathe
#
# Tracks the `main` branch via the `lathe` flake input (not a flake upstream,
# pulled in as flake = false). Run `nix flake update lathe` to bump it, then
# rebuild and paste the new vendorHash from the error message.
{ lib, buildGoModule, src }:

buildGoModule {
  pname = "lathe";
  version = "unstable-${src.shortRev or "dirty"}";

  inherit src;

  vendorHash = "sha256-3QV/ocKpCu2cmefLBCf4ZAAgFbN3500To5qpMinm+uM=";

  meta = with lib; {
    description = "Generates hands-on, source-backed tutorials for learning technical topics";
    homepage = "https://github.com/devenjarvis/lathe";
    license = licenses.mit;
    mainProgram = "lathe";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
