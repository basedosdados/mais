

#' @description `.onLoad` is automatically run when the user runs `library(basedosdados)` for the first time in the session.
#'
#'
#' @imports cli


.onLoad <- function(libname, pkgname) {


  if(Sys.getenv("billing_project_id") == "") {

    Sys.setenv(billing_project_set = FALSE)

  } else {

    Sys.setenv(billing_project_set = "user_has_set")

  }

  cli::cli_h1("Base dos Dados: Universalizando o acesso a dados no Brasil")

  cli::cli_h2("")
  cli::cli_ul()
  cli::cli_li("Site oficial: https://basedosdados.org/")
  cli::cli_li("Documentação: https://basedosdados.github.io/mais/")
  cli::cli_end()


  cli::cli_h2("Contatos")
  cli::cli_ul()

  cli::cli_li("Discord: discord.gg/tuaFbAPeq5")
  cli::cli_li("Twitter: @basedosdados")
  cli::cli_li("Email: contato@basedosdados.org")
  cli::cli_li("Telegram: t.me/joinchat/OKWc3RnClXnq2hq-8o0h_w")
  cli::cli_li("Github: github.com/basedosdados")
  cli::cli_li("LinkedIn: linkedin.com/company/base-dos-dados")
  cli::cli_li("Newsletter: https://basedosdados.hubspotpagebuilder.com/assine-a-newsletter-da-base-dos-dados")
  cli::cli_li("WhatsApp: https://chat.whatsapp.com/HXWgdFc1RmwCoblly5KPBZ")
  cli::cli_li("YouTube: https://www.youtube.com/c/BasedosDados")
  cli::cli_end()

  cli::cli_h3(
    "A Base dos Dados é um projeto open-source e todo gratuito para usuários. Para nos mantermos e crescermos precisamos do seu apoio. Quanto vale as horas do seu trabalho que poupamos?

    Nos apoie em https://apoia.se/basedosdados.")

}
