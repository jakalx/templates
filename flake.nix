{
  description = "Collection of templates for various projects";

  outputs = { self }: {
    templates = {
      haskell-cli = {
        path = ./haskell;
        description = "A haskell cli project";
      };
    };
    templates.default = self.templates.haskell-cli;
  };
}
