{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.alias = {
      a = "add";
      aa = "add --all";
      c = "commit";
      cm = "commit -m";
      s = "status";
      dc = "diff --cached";
      br = "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate";
      lg = "!git log --pretty=format:\"%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]\" --abbrev-commit -30";
      undo = "reset HEAD~1 --mixed";
      config-list = "config --list --show-origin";
      my-aliases = "config --get-regexp alias";
    };
  };
}
