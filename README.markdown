# Getting Started

## Company Details
Add your company information in a _details.yaml_ file using the following
structure.
```yaml
company:
  name: Acme Corp
  email: weapons@acme.corp
  website: http://www.acme.corp
  address: Danger ln. 101
  postalcode: 98765 ZY
  city: Danger City
  province: XX
  country: United States
  chamber_of_commerce_id: ********
  taxcode: TAX**
  iban: BANK**
```

## Client Details
In order to use client information in invoices you will be required to
construct seperate files for every client. These files contain the following
keys:

 - _name_ of the company
 - _representative_ being the person who acts as the ambassador towards your firm for the other company (project manager, the person you ultimately report to)
 - _address_ the streetname and building number for the paying department
 - _postalcode_ to which packages to the paying department may be sent
 - _city_ where the paying department is located

```yaml
name: Roadrunner Exterminators Inc.
representative: Cayote
address: Cliff 1
postalcode: 8000LBSANVIL
city: Luckville
```

## Work Log
A work log contains a list of committed work and some invoice details that the
work pertains to such as a serial number, invoice date and expiration date.
```yaml
invoice:
  serial: ABCD1234
  date:   3 September 2013
  expiration_date: 17 September 2013
  vat_rate: 21
keywords:
  - Roadrunner
  - TNT
work:
  - description: Delivering some firepower to Cayote
  - time: 20u
  - value: 1999.95
```

# Grand Idea
Simply helps me build generate invoices.

# おくりじょう, okurijō (送り状)
I don't know the first thing about the Japanese language, but like I do with my
other projects I enter a few related keywords into
[Google Translate](http://translate.google.com) and observe it's output in
different translations until finding something that I dub exotic enough.

If you google the phrase it will turn up as the Japanese word for the English
_invoice_ and _bill_.
