#!/bin/bash
# Descricao: Script facilitador de instalacao de aplicativos para uso do suporte
# Autor: Evandro Begati e Fabiano Henrique
# Colaboração: Fernando Souza https://github.com/tuxslack / https://www.youtube.com/@fernandosuporte
# Data: 18/11/2019


# Testa conectividade com a internet (ping no Google DNS)

if ! ping -c 1 google.com &>/dev/null; then

    yad --center --title="Erro de Conexão" \
        --text="Sem acesso à internet.\nVerifique sua conexão de rede." \
        --button=OK \
        --width=300 --height=100
        
    exit 1
fi


source /opt/projetus/facilitador/funcoes.sh

acao=$1

if [ "$acao" = "ACI" ]; then
  clear
  mkdir -p ~/.java/deployment/security
  echo "https://caged.maisemprego.mte.gov.br
  http://caged.maisemprego.mte.gov.br" >>~/.java/deployment/security/exception.sites

  showMessage "Nas próximas mensagens, marque a única opção que aparecer na tela e depois clique no botão Later, Continuar e Executar."

  rm -Rf ~/.java/deployment/cache
  cd $desktop_path
  rm -Rf jws_app_shortcut_*
  cd Validadores
  rm -Rf jws_app_shortcut_*
  cd $app_path

  javaws https://caged.maisemprego.mte.gov.br/downloads/caged/ACI-Install-JWS.jnlp

  aci_path=$(find "$desktop_path" -name "jws_app_shortcut_*")

  while [ ! -f "$aci_path" ]; do
    sleep 2
    aci_path=$(find "$desktop_path" -name "jws_app_shortcut_*")
  done

  mv "$aci_path" "$desktop_path/Validadores"
  rm -Rf ~/.local/share/applications/jws_app_shortcut*


  endInstall
fi

if [ "$acao" = "DIRF" ]; then
  clear
  cd "$desktop_path/Validadores"
  rm -Rf Dirf*
  cd $app_path
  download "https://servicos.receita.fazenda.gov.br/publico/programas/Dirf/2023/Dirf2023Linux-x86_64v1.0.sh" "$cache_path/Dirf.sh"

  chmod +x $cache_path/Dirf.sh

  echo $'#!/bin/bash 
    chmod +x '$cache_path'/Dirf.sh
    '$cache_path'/Dirf.sh --mode silent 
    chmod 777 /usr/share/applications/Dirf2023-program.desktop 
    cp /usr/share/applications/Dirf2023-program.desktop '"'$desktop_path/Validadores'"'
    chmod 777 '"'$desktop_path/Validadores/Dirf2023-program.desktop'"'
    rm -Rf /usr/share/applications/Dirf*
    '>$cache_path/exec.sh

  chmod +x $cache_path/exec.sh
  executar "pkexec $cache_path/exec.sh"

  endInstall
fi

if [ "$acao" = "GDRAIS" ]; then
  cd "$desktop_path/Validadores"
  rm -Rf GDRais*
  rm -Rf ~/GDRais*
  cd $app_path/cache 
  download "http://www.rais.gov.br/sitio/rais_ftp/GDRAIS2021-1.1-Linux-x86-Install.bin" "GDRAIS.bin"

  sleep 2
  mv GDRAIS.bin cache/GDRAIS.bin
  chmod +x $cache_path/GDRAIS.bin
  executar "$cache_path/GDRAIS.bin" 

  cd $app_path/atalhos

  echo $'[Desktop Entry]
        Exec='$user_path'/GDRais2021/gdrais.sh
        Terminal=false
        Type=Application
        Icon='$user_path'/GDRais2021/gdrais.ico
        Name[pt_BR]=GDRAIS
        '>GDRais2021.desktop


  cp $app_path/atalhos/GDRais2021* "$desktop_path/Validadores"
  cp "$desktop_path/Validadores/GDRais2021.desktop"  ~/.local/share/applications/
  chmod +x "$desktop_path/Validadores/GDRais2021.desktop"
  rm -Rf ~/.local/share/applications/Desinstalar*

  # ajustar atalho
  sed -i 's/Terminal=/Terminal=False/g' "$desktop_path/Validadores/GDRais.desktop"

  endInstall
    
fi

if [ "$acao" = "GRRF" ]; then
  # configurarWine
  download "http://www.caixa.gov.br/Downloads/fgts-grrf-aplicativo-arquivos/Instalador_GRRF_FB_ICP.EXE" "$cache_path/GRRF.exe"    
  executar "flatpak run --command=wine io.github.fastrizwaan.WineZGUI $cache_path/GRRF.exe /silent "
  mv ~/.var/app/io.github.fastrizwaan.WineZGUI/data/applications/wine/GRRF/GRRF\ Eletronica.desktop "$desktop_path/Validadores"
  rm -Rf ~/.local/share/applications/wine/GRRF*
  endInstall
fi

if [ "$acao" = "SEFIP" ]; then
  # configurarWine
  cd $cache_path
  download "https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/sefip/setupsefipv8_4.exe" "$cache_path/sefip.exe"
  cd $cache_path
  executar "flatpak run --command=wine io.github.fastrizwaan.WineZGUI $cache_path/sefip.exe /silent"
  mv "$desktop_path/SEFIP.desktop" "$desktop_path/Validadores"
  rm -Rf ~/.var/app/io.github.fastrizwaan.WineZGUI/data/applications/wine/SEFIP
  endInstall
fi

if [ "$acao" = "SVA" ]; then
  # configurarWine
  cd "$desktop_path/Validadores"
  rm -Rf SVA*
  download "https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/auditoria-fiscal/arquivos/sva-arquivos/instala_sva-3-3-0.exe/@@download/file" "$cache_path/sva.exe"
  executar "flatpak run --command=wine io.github.fastrizwaan.WineZGUI $cache_path/sva.exe /silent "
  sleep 1
  mv ~/.var/app/io.github.fastrizwaan.WineZGUI/data/applications/wine/Programs/Programas\ RFB/SVA\ 3.3.0/SVA\ 3.3.desktop "$desktop_path/Validadores"
  rm -Rf ~/.var/app/io.github.fastrizwaan.WineZGUI/data/applications/wine/Programs/Programas\ RFB/SVA*
  endInstall
fi
