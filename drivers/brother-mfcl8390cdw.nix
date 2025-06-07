{
  lib,
  stdenv,
  fetchurl,
  rpm,
  cpio,
  autoPatchelfHook,
  makeWrapper,
  cups,
  ghostscript,
  gnugrep,
  glibc,
  file,
}:

stdenv.mkDerivation {
  pname = "brother-mfc-l8390cdw";
  version = "3.5.1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105782/mfcl8390cdwpdrv-3.5.1-1.i386.rpm";
    sha256 = "sha256-3cAVrutoFYjJkmzhrUtNY3hVfcJdEhZ2M0FjfENKCoQ=";
  };

  nativeBuildInputs = [
    rpm
    autoPatchelfHook
    makeWrapper
    cpio
  ];

  buildInputs = [
    cups
    ghostscript
    gnugrep
    glibc
    file
  ];

  unpackPhase = ''
    rpm2cpio $src | cpio -idm
  '';

  installPhase = ''
    mkdir -p $out/opt/brother/Printers/mfcl8390cdw
    cp -r opt/brother/Printers/mfcl8390cdw/* $out/opt/brother/Printers/mfcl8390cdw/

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln -s $out/opt/brother/Printers/mfcl8390cdw/cupswrapper/brother_lpdwrapper_mfcl8390cdw $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcl8390cdw/cupswrapper/brother_mfcl8390cdw_printer_en.ppd $out/share/cups/model/

    # Fix paths in wrapper script
    substituteInPlace $out/opt/brother/Printers/mfcl8390cdw/cupswrapper/brother_lpdwrapper_mfcl8390cdw \
      --replace "/opt/brother/Printers/mfcl8390cdw" "$out/opt/brother/Printers/mfcl8390cdw" \
      --replace "/usr/bin/grep" "${gnugrep}/bin/grep" \
      --replace "/usr/bin/gs" "${ghostscript}/bin/gs"
      
    # Fix permissions
    chmod +x $out/opt/brother/Printers/mfcl8390cdw/cupswrapper/brother_lpdwrapper_mfcl8390cdw
    chmod +x $out/lib/cups/filter/brother_lpdwrapper_mfcl8390cdw
  '';

  meta = with lib; {
    description = "Brother MFC-L8390CDW printer driver";
    homepage = "https://support.brother.com/";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
    maintainers = [ ];
  };
}
