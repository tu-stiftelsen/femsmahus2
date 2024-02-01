# Fem små hus

Fem små hus är ett internetinfrastruktur-projekt med mål att designa och
ta fram en robust infrastruktur för Internet i Sverige. Den tar avstamp i
Internetmodellen med IPv6 som centralt protokoll för paketförmedling, och
är baserad på en princip av att nätet ska gå fortare att laga än vad en
antagonist kan ha sönder det.

## English

Fem små hus, literally *five small houses*, is a Swedish Internet
infrastructure design project. This repository belongs to the second cycle
of the project, called *Robust Internet*. 

## Detta repo

I undermappar här finns (utkast) på specifikationer på delar av en robust
internetinfrastruktur. Specifikationerna är skrivna i markdown
(`.md`-filer) som med hjälp av `pandoc` och indirekt `lualatex` genererar
färdiga pdf:er. De figurer som förekommer är beroende av `mermaid` och
`mermaid-cli`. 

## Installation av beroenden

### Ubuntu

Följande installerar nödvändiga beroenden på Ubuntu 22.04:

````bash
apt install -y pandoc # övergripande ramverk för att generera 
apt install -y texlive-latex-base texlive-latex-extra texlive-lang-european texlive-luatex # texlive och andra beroenden
apt install -y librsvg2-bin # resurser för svg:er som behövs för att generera pdf:erna
apt install -y npm # behövs för mermaid-cli
npm install -g @mermaid-js/mermaid-cli # används för att generera figurer
````

### MacOS

Följande installerar nödvändiga beroenden på MacOS givet att Homebrew
(`brew`) är installerat:

```bash
brew install pandoc npm # pandoc och npm
brew install --cask tex-live-utility 
npm install -g @mermaid-js/mermaid-cli # används för att generera figurer
```

Sedan behöver du hämta ytterligare resurser med `tlmgr` (dvs
`tex-live-utility` från ovan).

```bash
sudo tlmgr install luatexbase babel-swedish biblatex fontspec hyphen-swedish
```