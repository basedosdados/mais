

#' @description `.onLoad` is automatically run when the user runs `library(basedosdados)` for the first time in the session.
#'
#'
#' @imports cli


.onLoad <- function(libname, pkgname) {


  if(Sys.getenv("billing_project_id") == "") {

    Sys.setenv(billing_project_set = FALSE)

  } else {

    Sys.setenv(billing_project_set = "env")

  }


  Sys.setenv(billing_project_set = FALSE)

  cli::cli_h1("Base dos Dados: Facilitando o acesso a dados no Brasil")
  cli::cli_h2("Contatos")
  cli::cli_ul()
  cli::cli_li("Twitter: @basedosdados")
  cli::cli_li("Email: contato@basedosdados.org")
  cli::cli_li("Telegram: t.me/joinchat/OKWc3RnClXnq2hq-8o0h_w")
  cli::cli_li("Apoia.se: apoia.se/basedosdados")
  cli::cli_li("Github: github.com/basedosdados")

}
