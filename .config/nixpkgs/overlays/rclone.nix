self: super: 
{
  rclone = super.rclone.overrideAttrs (old: rec{
    version = "1.67.0";
    src = super.fetchFromGitHub {
      owner = "rclone";
      repo = "rclone";
      rev = "v${version}";
      hash = "sha256-rTibyh5z89QuPgZMvv3Y6FCugxMIytAg1gdCxE3+QLE=";
    };
  });
}
