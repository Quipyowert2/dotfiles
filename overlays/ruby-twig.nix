final: prev: {
  rubyPackages = prev.ruby.override (rFinal: rPrev: {
    twig = rFinal.buildRubyGem {
      pname = "twig";
      version = "1.7.1";
      sha256 = "sha256-XZadbVU6Ls9VAlnEjTYD35CUPAmvLJiSArg8wmkLOo8=";
    };
  });
}
