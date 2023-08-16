---
title: 'Teknisk definition av framtidssäker internettjänst'
shorttitle: 'Framtidssäker internettjänst'
designation: '5T:3'
version: '0.1'
date: '2023-08-16'
toc: false
versions:
  - version: '0.1'
    description: 'Utkast'
---

# Inledning

Det här utkastet beskriver en framtidssäker internet-infrastruktur, utformad enligt internets
grundläggande principer. Det bygger på den internetdefinition med nåbara ändpunkter som låg till
grund för IETF:s skapande av IPv6.

Den viktigaste aspekten för en framtidssäker internet-infrastruktur är **end-to-end-principen**:
nätverkets enda uppgift är att vidarebefordra paket mellan ändpunkter, utan att bearbeta eller
förändra innehållet.  End-to-end-principen gör nätverket symmetriskt, vilket innebär att alla
ändpunkter är likvärdiga och kan utväxla vilken information som helst utan föregående koordinering,
signalering eller tillstånd. Det finns inget som hindrar en användare av en anslutning att själv
införa ytterligare funktioner som begränsar trafik och funktionalitet på det sätt användaren önskar,
till exempel brandvägg eller NAT-funktion.

# IPv4 bredbandsaccess

På grund av bristande tillgång till IPv4-adresser passerar majoriteten av internetanvändarnas trafik
idag genom adressöversättare. Här beskrivs en infrastruktur där IPv6 används som bärare av *all*
elektronisk kommunikation.

Tillgång till IPv4 ("IPv4 bredbandsaccess") levereras som en tjänst över IPv6-basfunktionen och
presenteras mot kunden från abonnentplacerad utrustning. Det finns flera IETF-definierade metoder
för detta, exempelvis med hjälp av CGNAT eller tunnling av globalt nåbara IPv4-adresser. Jämfört med
så kallad "dual stack" bedöms denna modell minska såväl systemkomplexitet som kostnader för
utbyggnad och löpande drift av infrastrukturen.

# OSI-modellen

Den så kallade OSI-modellen^[^1]^ definierar överföring av datatrafik i 7 olika lager. I detta
dokument refererar vi till de grundläggande lagren L1-L4 enligt nedan.

Lager 1 fysiska lagret
Lager 2 datalänklagret
Lager 3 nätverkslagret (adressering, routing etc)
Lager 4 transportlagret (uppdelning i datapaket med omsändningar etc)

# IPv6 internetanslutning

Lager 3 i den levererade internetanslutningen ska i samtliga fall utgöras av IPv6 enligt RFC 8200.

## Fast anslutning

### Lager 1 & 2

Följande standarder accepteras i avlämningspunkten:

* 1 Gbit Ethernet twisted pair, 802.??
* 1 Gbit Ethernet optical duplex SM fiber, 802.??
* 10 Gbit Ethernet twisted pair, 802.??
* 10 Gbit Ethernet optical single fiber, 802.??
* 10 Gbit Ethernet optical duplex SM fiber, 802.??
* 100 Gbit Ethernet-avlämning specas under 2024
* 400 Gbit Ethernet-avlämning specas under 2025

Automatisk förhandling av duplex och flödeskontroll, alternativt statisk
definition i kundprofil. Inga taggar (IEEE 802.1Q).

## Mobil anslutning

### Lager 1 & 2

Följande standarder accepteras i avlämningspunkten:

* 1 Gbit Ethernet twisted pair, 802.11(\*)
* 10 Gbit Ethernet twisted pair, 802.11(\*)

# MTU

IPv6 MTU ska vara 9000 byte över media med stöd för detta. Om den direktanslutna kundutrustningen
endast klarar 1500 byte ska anpassning ske automatiskt (IETF BCP 39). Leverans av MTU på 9180 byte
ska ske på begäran om avlämningsmediet har stöd för detta.

# ICMP

Korrekt hantering av ICMP i alla nätelement mellan sändare och mottagare är en förutsättning för
full funktion.

# IP-adresser

Standardtilldelningen av IPv6-adresser är ett fast ett /56-block (256 /64-block) från operatörens
adressblock. Minsta tilldelade block för en fast anslutning är /60.

Till nätet som ansluter användaren (avlämningsnätet) används i första hand första eller sista
/64-block ur kundens allokering. Detta signaleras i DHCP genom användandet av "PD-exclude".
Avlämningsnätet kan också tilldelas ett annat globalt adresserbart prefix ur IPv6-operatörens
adressblock. Oavsett hur adresserna i avlämningsnätet tilldelas ska det vara möjligt att adressera
minst 16 direkt anslutna enheter. De ska kunna nå hela det globala internet.

Avlämningsnätet annonseras med ICMPv6 *router advertisement* (RA) mot abonnenten.

Operatören ska vidarebefordra paket som har destinationsadresser inom användarens tilldelade
adressrymd till minst en enhet ansluten till avlämningsnätet.

Ändring av de tilldelade adresserna för en anslutning ska undvikas så långt som möjligt.

# IPv6 NDP

Operatörens avlämningsutrustning ska kunna hantera minst 16 samtidiga NDP-sessioner för utrustning
ansluten direkt till avlämningsnätet.  Tilldelade adresser ska kunna nå alla IPv6-destinationer i
Sverige.

# Rekommendation till ansluten utrustning

Eftersom adresser är "semistatiska" är det lämpligt att ansluten utrustning "kommer ihåg" sin
adressering i händelse av kraftavbrott och använder den initialt efter återstart. Därigenom erhålls
tillgänglighet i driftfall där paketförmedling fungerar men stödfunktioner, som DHCPv6, är
otillgängliga.

I fall när användaren har lokal DHCP-vidaredelegering är det lämpligt att även adressdelegeringar
för de enheter som skall kunna nås globalt sparas så att de är nåbara direkt vid en återstart.

# IP-transparens

Ett korrekt formaterat IPv6-paket avsänt från godtycklig avsändare inom
Sverige med godtyckligt innehåll (IP-protokoll/port/etc) ska
vidarebefordras till användaren oförvanskat.

# RPF-kontroll

Internetoperatören skall bara vidarebefordra paket som har avsändaradresser inom det adressområde
som tilldelats användaren.

# Colours

I det fall olika IPv6-adressrymder används för olika tilläggstjänster skall dessa taggas med
\"colours\" (rfc??) som är koordinerade i ett publikt tillgängligt nationellt register.

# Tillgänglighet

Längsta tillåtna avbrott på utrustning sekundärt placerad i nätet är 60 sekunder, oberoende av
felorsak.

# Verifiering av internetanslutning

## Test av protokolltransparens

Paket skickas med en hastighet av ett paket per sekund till referensmottagare. I det fall vald
referensmottagare inte erhåller paket väljer avsändaren en annan mottagare. I fall ingen mottagare
erhåller paket är förbindelsen trasig. Innehåll i paketen väljs slumpmässigt.

Referensmottagarna tar emot paket och skickar ICMP-svar till avsändaren.  Det finns fyra typer av
referensmottagare med stöd för olika MTU:

* 576 byte
* 1500 byte
* 4470 byte
* 9000 byte

Krav:
* För godkänt resultat ska avsändaren ha mottagit svar från
  referensmottagaren på 249 av 250 avsända paket (99,6%) med IPv6 MTU på 9000 byte, 4470 byte, 1500
  byyte och 576 byte.
* Paket som tar längre tid än 20 ms (en väg) att nå mottagaren räknas som förlorat.
* Kommer mer än 2% av paketen fram i oordning räknas det som avbrott på förbindelsen.

## Test av adressering och routing

Korrekt formaterade IPv6-paket med slumpmässigt innehåll och en MTU på 1500 byte skickas till två
slumpmässigt utvalda mottagaradresser på avlämningsnätet samt till en och samma adress på
referensmottagaren skickas från en godtycklig avsändare inom Sverige.

Krav:

* För godkänt resultat ska mottagarna ha tagit emot 249 av 250 avsända paket (99,6%).

Korrekt formaterade IPv6-paket med slumpmässigt innehåll och en MTU på 1500 byte skickas till
slumpmässigt utvalda mottagaradresser inom det adressblock som tilldelats användaren (exklusive
avlämningsnätets adresser).

Krav:

* För godkänt resultat ska den enhet som tilldelats adresserna av internetoperatörens utrustning ha
  mottagit 249 av 250 avsända paket (99,6%).

## Mätning av dynamiska prestanda

Här avses IPv6-genomströmning. Overhead på lägre läger, exempelvis Ethernet, är exkluderat.

Mätning av dynamiska prestanda sker genom att grupper av IPv6-paket med 128 byte nyttolast skickas
utan tidsglapp mellan paketen. Varje grupp innehåller 4 paket per avtalad kilobit
anslutningshastighet. Exempelvis innebär 1 Gbit/s kundanslutning 3800 paket om 128 byte per grupp.

Det ska finnas fler än tre referenssändare/-mottagare i Sverige. Drivs av ansvarig myndighet.

Följande tester genomförs:

* Från en referenssändare till en adress i användarens anslutningsnät, i en takt motsvarande 100% av
  avtalad bandbredd
* Från en adress i användarens anslutningsnät till en referensmottagare, i en takt motsvarande 100%
  av avtalad bandbredd
* Från en referenssändare till en adress i användarens anslutningsnät, i en takt motsvarande 95% av
  avtalad bandbredd.
* Från en adress i användarens anslutningsnät till en referensmottagare, i en takt motsvarande 95%
  av avtalad bandbredd.

Krav:

* Max ett paket per sänd grupp får försvinna vid de två första testerna.
* Inga paket får försvinna vid de två sista testerna.
* Godkända prestanda ska uppnås mot samtliga referenssändare/-mottagare i Sverige.

[^1]:
    [*https://sv.wikipedia.org/wiki/OSI-modellen*](https://sv.wikipedia.org/wiki/OSI-modellen)
