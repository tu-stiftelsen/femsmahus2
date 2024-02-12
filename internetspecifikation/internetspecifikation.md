---
lang: sv-SE
title: 'TU:s internetspecifikation'
shorttitle: 'TU:s internetspecifikation'
designation: '5T:3'
version: '0.3'
date: '2024-02-08'
toc: false
fontfamily: courier new
---

# Inledning

Det här dokumentet beskriver en del av designen i en internetinfrastruktur för
Sverige. Infrastrukturen är baserad på förmedling av IPv6-paket i enlighet med
IETF:s designprinciper. Den viktigaste av detta är **end-to-end**-principen som
innebär att ett nätverks enda uppgift är att vidarebefordra paket mellan
ändpunkter, utan att bearbeta eller förändra innehållet.

End-to-end-principen gör nätverket symmetriskt, vilket innebär att alla
ändpunkter är likvärdiga och kan utväxla vilken information som helst utan
föregående koordinering, signalering eller tillstånd. Trots detta finns
det inget som förhindrar en användare att själv införa ytterligare
funktioner som begränsar trafik och funktionalitet, exempelvis brandväggar
eller adressöversättningsfunktioner.

Arbetet med att fastställa internets arkitekturprinciper och standarder sker
inom ramen för **The Internet Engineering Task Force (IETF)**. Resultaten av
IETF:s arbete publiceras i dokumentserien **Request for Comments (RFC)**. För
att ett nätverk som utgör en del av internet ska vara fungerande och
framtidssäkert är det en förutsättning att det är designat på det sätt som
beskrivs av gällande RFC:er.


## Användning och målgrupp

Det här dokumentet är tänkt att användas av internetoperatörer (ISP:er) vid
design av deras tjänster. Det kan även användas av slutanvändare för att
verifiera att ISP:er lever upp till de krav som ställs på dem.

## Terminologi

I det här dokumentet avser begreppet **IP** enbart **IPv6**.

## Utveckling av specifikationen

Utvecklingen av den här specifikationen är pågående. Aktuell version av
specifikationen finns alltid tillgänglig på projektets Github-sida:
[https://github.com/tu-stiftelsen/femsmahus2](https://github.com/tu-stiftelsen/femsmahus2).
Bidrag i form av ändringsförslag och "issues" välkomnas.

# Nätverksmodell

I den här specifikationen används en nätverksmodell där de fyra nedersta
lagren benämns enligt nedan:

- **Lager 1** Fysiska lagret
- **Lager 2** Datalänklagret
- **Lager 3** Nätverkslagret (adressering, routing etc)
- **Lager 4** Transportlagret (uppdelning i datapaket med omsändningar etc)

# Lager 3: Förmedling av IPv6

Grunden för all kommunikation enligt den här specifikationen är förmedling av IPv6-paket. Lager 3 i
den levererade internetanslutningen ska därför alltid utgöras av IPv6 enligt
[RFC&nbsp;8200](https://doi.org/10.17487/rfc8200).

- **Krav:**
  - En internetanslutning **ska** baseras på förmedlning av IPv6-paket

## Tilldelning av IP-adresser

I IPv6 tilldelas adresser i block. Storleken på ett block uttrycks normalt som ett snedstreck följt
av antalet fasta bitar i början av blockets adresser. Exempelvis innebär tilldelning av ett
/48-block att kunden tilldelas en mängd adresser där de första 48 bitarna i adressen är desamma.
Kunden är fri att fördela de återstående 80 bitarna inom sitt nät. Det minsta block som tilldelas en
enskild broadcastdomän är normalt /64.

Samtliga tilldelade adresser ska vara globalt adresserbara.

Tilldelning av adressblock till användare sker genom Dynamic Host Configuration Protocol version 6
(DHCPv6) prefix delegation (PD) [RFC&nbsp;8415](https://doi.org/10.17487/rfc8415).

Standardtilldelningen av IP-adresser till en kund ska vara ett /56-block, vilket motsvarar 256
/64-block.

Det block som ansluter användare till operatör (avlämningsnätet) tilldelas
normalt det första eller sista /64-blocket ur användarens allokering. Det
är även tillåtet att tilldela ett annat globalt adresserbart adressblock
till avlämningsnätet. Avlämningsnätet annonseras mot användaren genom
ICMPv6 router advertisement (RA). I de fall ett adressblock ur användarens
allokering används för avlämningsnätet ska det indikeras för användaren
genom DHCPv6 PD exclude [RFC&nbsp;6603](https://doi.org/10.17487/rfc6603).
Det ska vara möjligt för kunden att ansluta minst 16 enheter direkt till
avlämningsnätet.

Föredragen livstid (preferred lifetime) för DHCPv6-lease är 604 800
sekunder (7 dagar). Giltig livstid (valid lifetime) är 2 592 000 sekunder
(30 dagar).

Ändring av de tilldelade adresserna för en anslutning ska undvikas så
långt som möjligt. I de fall ändring sker ska trafik till och från de
tidigare tilldelade adresserna fortsätta förmedlas under lägst tre
månader.

- **Krav:**
  - Adresser tilldelade av operatör till användare **ska** vara globalt
    adresserbara.
  - Tilldelning av adresser **ska** ske genom DHCPv6 PD
    ([RFC&nbsp;8415](https://doi.org/10.17487/rfc8415)).
  - Tilldelning av adresser **ska** ske med minst ett /56-block.
  - DHCPv6 PD exclude **ska** användas för att indikera de adresser som
    avlämningsnätet använder.
  - Avlämningsnätet **ska** klara av *minst* 16 direktanslutna enheter.
  - Ändring av tilldelade adresser **ska** informeras om tre månader innan
    ändring.
- **Rekommendation:**
  - Tilldelade adresser **bör** inte ändras.

### Rekommendation för kundansluten utrustning vid anslutningspunkt

Eftersom adresser är semistatiska, dvs. förändras relativt sällan, är det lämpligt att ansluten
utrustning sparar sina tilldelade adresser och adressblock vid omstarter och kraftavbrott. I
händelse av felfall där paketförmedling fungerar men stödfunktioner, exempelvis DHCPv6, är
otillgängliga blir det då fortfarande möjligt att förmedla paket.

- **Krav:**
  - Tilldelade adresser **ska** fungera under hela DHCPv6-lease tiden,
    även om DHCPv6-funktionen går ner.

### Rekommendation för kundanslutning utrustning bakom anslutningspunkt

Hosts bakom anslutningspunkt ska hantera både DHCPv6 och SLAAC för
adresstilldelningen.

- **Krav:**
  - Enskilda enheter bakom anslutningspunkt **ska** ska stödja DHCPv6 och SLAAC.
  - Adresser tilldelade till enheter bakom anslutningspunkt **ska** vara globalt
    adresserbara.
- **Rekommendationer:**
  - IPv6-noder **bör** fungera enligt
    [RFC&nbsp;8504](https://doi.org/10.17487/rfc8504).

## Paketförmedling

**Förmedling** Operatören ska vidarebefordra IPv6-paket adresserade till adresser inom användarens
tilldelade adressrymd till minst en enhet ansluten till avlämningsnätet.

**Transparens** Ett korrekt formaterat IPv6-paket adresserat till användarens tilldelade adressrymd
ska vidarebefordras till användarens utrustning oförvanskat, oaktat innehåll eller avsändare.
Detsamma gäller paket från användarens utrustning till alla globalt adresserbara IPv6-adresser. I
sammanhanget är det viktigt att notera att korrekt och oförvanskad förmedling av Internet Control
Message Protocol version 6 (ICMPv6)-paket en förutsättning för full funktion i IPv6, vilket inte är
fallet för IPv4.

**Maximum transmission unit (MTU)** MTU i anslutningen ska vara 9000&nbsp;byte. I de fall kundens
anslutna utrustning inte har stöd för detta ska anpassning av MTU till 1500&nbsp;byte ske
automatiskt. Om avlämningsmediet har stöd för MTU på 9180&nbsp;byte ska det användas på begäran av
kunden.

**Neighbor Discovery Protocol (NDP)** Operatörens avlämningsutrustning ska
kunna hantera minst 16 samtidiga NDP-sessioner för utrustning ansluten
direkt till avlämningsnätet.

**Reverse-path forwarding (RPF)-kontroll** Internetoperatören ska genomföra RPF-kontroll av paket
förmedlade från användaren. Endast paket med avsändaradresser från användarens tilldelade
adressområde ska vidarebefordras.

**Colours** I det fall olika adressrymder används för olika tilläggstjänster ska taggning med
colours ske (RFC&nbsp;xxxx). Taggningen ska vara densamma för alla operatörer i Sverige.

**Tillgänglighet** Längsta tillåtna avbrott på utrustning i operatörens nät som inte är
avlämningsutrustning är 60 sekunder. Det här kravet innebär att all operatörens utrustning, utom
avlämningsutrustningen, måste vara redundant. Längsta tillåtna avbrott på operatörens
avlämningsutrustning är 8 timmar.

- **Krav:**
  - Operatören **ska** förmedla IPv6-paket adresserade till adresser inom
    användarens adressrymd till minst en enhet ansluten till avlämningsnätet.
  - Operatören **ska** stödja en MTU på 9000&nbsp;byte och 1500&nbsp;byte på
    avlämningsnätet.
  - Operatören **ska** erbjuda en MTU på 9000&nbsp;byte som standard och anpassa
    till 1500&nbsp;byte om så krävs.
  - Operatören **ska** kunna hantera *minst* 16 samtidigare NDP-sessioner för
    användarutrustning ansluten direkt till avlämningsnätet.
  - Operatören **ska** enbart förmedla vidare paket från användaren med
    avsändaradress inom den tilldelade adressrymden.
  - Operatören **ska** följa etablerad paket-taggningsstandard.
  - Operatören **ska** designa nät med redudans och erbjuda tjänster utan
    nedtid.
  - Operatören **ska** kunna avhjälpa utrustningsfel i avlämningsnätet inom 8
    timmar.
- **Rekommendation:**
  - Operatören **bör** erbjuda en MTU på 9180&nbsp;byte på avlämningsnätet på
    användarens begäran.

# Lager 1 & 2: specifikation för överlämning

## Fast anslutning

Följande standarder accepteras i avlämningspunkten:

* 1 Gbit Ethernet twisted pair (IEEE 802.3ab)
* 1 Gbit Ethernet optical duplex SM fiber, (IEEE 802.3ah ??)
* 10 Gbit Ethernet twisted pair (IEEE 802.3an)
* 10 Gbit Ethernet optical single fiber (IEEE 802.3ae ??)
* 10 Gbit Ethernet optical duplex SM fiber (IEEE 802.3ae ??)
* 100 Gbit Ethernet-avlämning specificeras under 2024
* 400 Gbit Ethernet-avlämning specificeras under 2025

Förhandling av duplex och flödeskontroll ska ske automatiskt om inte annat har avtalats. Så kallad
VLAN-taggning av virtuella nätverk (IEEE 802.1Q) ska inte ske.

- **Krav:**
  - Operatören **ska** avlämna nät enligt någon av specifikationerna ovan.


## Trådlös anslutning

- **FIXME:** Utveckla lite
- **FIXME:** Lägg tillbaka mobiltelefonitexten och dubbelkolla formuleringar

Avlämning av trådlös internetanslutning ska ske genom Wi-Fi (IEEE 802.11a/b/g/n/ac/ax/be).

- **Krav:**
  - Operatören **ska** avlämna nät enligt någon av specifikationerna ovan.

# Övriga kommentarer och rekommendationer

## IPv4-tjänst

Utgångspunkten för den arkitektur som specificeras här är att IPv6 används
som bärare för all elektronisk kommunikation. Tillgång till IPv4 ("IPv4
bredbandsaccess") ska därför levereras som en tjänst över IPv6 och
presenteras mot kunden från abonnentplacerad utrustning. Det finns flera
IETF-definierade metoder för detta, exempelvis med hjälp av CGNAT eller
tunnling av globalt nåbara IPv4-adresser. Jämfört med "dual stack"-lösning
bedöms denna arkitektur minska såväl systemkomplexitet som kostnader för
utbyggnad och löpande drift av infrastrukturen.

- **Rekommendation:**
  - Operatören **bör** erbjuda en single-stack lösning baserat på IPv6.
  - Operatören **bör** erbjuda andra protokoll och adressrymber, såsom IPv4,
    över IPv6.

# Verifiering av internetanslutning

## Referenssändare och -mottagare

För verifiering av att en internetanslutning uppfyller kraven i den här specifikationen ska det
finnas ett antal referenssändare- och mottagare placerade fysiskt på olika platser i Sverige och
logiskt på olika platser i nätverket. Det ska finnas minst tre referenssändare- och mottagare i
Sverige som drivs på uppdrag av ansvarig myndighet.

## Test av transparens

Vid test av transparens skickas paket med slumpmässig nyttolast och lager 4-protokoll till en
referensmottagare med en hastighet av ett paket per sekund. Referensmottagarna tar emot paket och
skickar ICMP-svar till avsändaren. I det fall referensmottagaren inte erhåller paket väljs en annan
mottagare. I fall ingen mottagare erhåller paket är testet underkänt.

Följande referensmottagare med stöd för olika MTU ska användas:

* 576 byte
* 1500 byte
* 4470 byte
* 9000 byte

Detta för att ge en god testbredd.

- **Testkrav:**
  - För godkänt resultat ska avsändaren ha mottagit svar från referensmottagaren på 249 av 250
  avsända paket (99,6%) med IPv6 MTU på 9000&nbsp;byte, 4470&nbsp;byte, 1500&nbsp;byte och
  576&nbsp;byte.
  - Paket som tar längre tid än 20&nbsp;ms (en väg) att nå mottagaren räknas som förlorat.
  - Kommer fler än fem (2%) av paketen fram i oordning räknas det som avbrott på förbindelsen.

## Test av adressering och routing

Korrekt formaterade IPv6-paket med slumpmässig nyttolast och lager 4-protokoll skickas till
två slumpmässigt utvalda mottagaradresser på avlämningsnätet samt till en och samma adress på
referensmottagaren skickas från en godtycklig avsändare inom Sverige. Storleken på paketen ska
motsvara en MTU på 1500&nbsp;byte.

- **Testkrav:**
  - För godkänt resultat ska mottagarna ha tagit emot 249 av 250 avsända paket (99,6%).

Korrekt formaterade IPv6-paket med slumpmässig nyttolast och lager 4-protokoll skickas till
slumpmässigt utvalda mottagaradresser inom det adressblock som tilldelats användaren (exklusive
avlämningsnätets adresser). Storleken på paketen ska motsvara en MTU på 1500&nbsp;byte.

- **Testkrav:**
  - För godkänt resultat ska den enhet som tilldelats adresserna av internetoperatörens utrustning ha
  mottagit 249 av 250 avsända paket (99,6%).

## Mätning av dynamiska prestanda

Vid mätning av dynamiska data mäts genomströmning av lager 3, dvs. IPv6. Overhead på lägre läger,
exempelvis Ethernet, är exkluderat. Mätningen sker genom att grupper av IPv6-paket med 128 byte
nyttolast skickas utan tidsglapp mellan paketen. Varje grupp innehåller 4 paket per avtalad kilobit
anslutningshastighet. Exempelvis innebär 1&nbsp;Gbit/s kundanslutning 3800 paket om 128 byte per grupp.

Följande tester genomförs:

* Från en referenssändare till en adress i användarens anslutningsnät, i en takt motsvarande 100% av
  avtalad bandbredd.
* Från en adress i användarens anslutningsnät till en referensmottagare, i en takt motsvarande 100%
  av avtalad bandbredd.
* Från en referenssändare till en adress i användarens anslutningsnät, i en takt motsvarande 95% av
  avtalad bandbredd.
* Från en adress i användarens anslutningsnät till en referensmottagare, i en takt motsvarande 95%
  av avtalad bandbredd.

Dessa tester ska utvärderas mot testkraven.

- **Testkrav:**
  - Max ett paket per sänd grupp får försvinna vid de två första testerna.
  - Inga paket får försvinna vid de två sista testerna.
  - Godkända prestanda ska uppnås mot samtliga referenssändare/-mottagare i Sverige.
