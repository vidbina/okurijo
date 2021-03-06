# Getting Started
Considering that all things are well with your system, you will just need to
run ```./render --help``` to get a list of available options.

If the previous command returns something sensible you may try building a 
dummy invoice with some example data.

```./render -t examples/template.liquid -c examples/client.yaml -w examples/work.yaml -m examples/me.yaml > invoice.md```

The `examples/template.liquid` file is the liquid template to a markdown file.
The output therefore is just another markdown file named `invoice.md` in this 
case.

The following information is passed to the script in order to generate our
invoice:

  - information to the client (with the `-c` flag for _client_)
  - the work details (with the `-w` flag for _work_)
  - your company's information (with the `-m` flag for _me_)

Upon errors the output file with remain empty.

## Company Details
Add your company information in a _details.yaml_ or another file using the 
following structure.
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

By default `details.yaml` in the current working directory is consulted for the
company's information. If you want to specify the company file to use, 
use the `-m PATH` option.

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
    time: 20u
    value: 1999.95
```

The work entries have descriptions, times and values. For the `time` property 
you are free to enter content like `12min`, `3hrs`, `9aeons`. The `time` 
property simply has a representational value. The `value` property you must 
enter a valid number because we will use this entry to determine the totals.

# Grand Idea
Simple tool to help me generate invoices from the CLI.

# おくりじょう, okurijō (送り状)
I don't know the first thing about the Japanese language, but like I do with my
other projects I enter a few related keywords into
[Google Translate](http://translate.google.com) and observe it's output in
different languages until finding something that I dub exotic and likeable 
enough.

If you google the phrase it will turn up as the Japanese word for the English
_invoice_ and _bill_.
