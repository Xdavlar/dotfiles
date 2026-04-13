{ ... }: {
  flake.nixosModules.nano = { ... }: {
    programs.nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
      set autoindent
      set linenumbers
    '';
  };
}
