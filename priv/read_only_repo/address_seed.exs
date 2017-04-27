alias Healthlocker.{ReadOnlyRepo, EPJSPatientAddressDetails}

ReadOnlyRepo.insert!(%EPJSPatientAddressDetails{
  Patient_ID: 201,
  Address_ID: 1,
  Address1: "123 High Street",
  Address2: "London",
  Address3: "UK",
  Post_Code: "E1 8UW",
  Tel_home: "02085 123 456"
})

ReadOnlyRepo.insert!(%EPJSPatientAddressDetails{
  Patient_ID: 202,
  Address_ID: 2,
  Address1: "17 Lower Street",
  Address2: "London",
  Address3: "UK",
  Post_Code: "CR6 9GH",
  Tel_home: "02085 957 365"
})

ReadOnlyRepo.insert!(%EPJSPatientAddressDetails{
  Patient_ID: 203,
  Address_ID: 3,
  Address1: "65 Upper Street",
  Address2: "London",
  Address3: "UK",
  Post_Code: "SE4 0BL",
  Tel_home: "02085 446 954"
})
