//
//  ContactDataManagerTests.swift
//  ContactManagerTests
//
//  Created by Siju Satheesachandran on 19/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import XCTest
import Contacts
@testable import ContactManager
class ContactDataManagerTests: XCTestCase {
    var contactManager:ContactDataManager!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        contactManager = ContactDataManager()
    }
    
    func dummyContact() ->CNMutableContact  {
        let contact = CNMutableContact()
        contact.familyName = "familyName"
        contact.givenName = "givenName"
        contact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberiPhone,
            value: CNPhoneNumber(stringValue: "12345678"))]
        return contact
    }
    func testContactResultNotEmptyWhenAddNewContact() {
        contactManager.addContactWith(contact: dummyContact())
        XCTAssertTrue(contactManager.allContactResults.count > 0)
    }
    func testContactResultChangeWhenUpdateFamilyName() {
        let testFamilyName = "Satheesachandran"
        let contact = dummyContact()
        contactManager.addContactWith(contact: contact)
        contact.familyName = testFamilyName
        contactManager.updateContact(updatedContact: contact)
        XCTAssertTrue(contactManager.allContactResults.count > 0)
        XCTAssertEqual(contactManager.allContactResults.first?.familyName, testFamilyName)
        
    }
    func testContactResultChangeWhenUpdateGivenName() {
        let testGivenName = "Siju"
        let contact = dummyContact()
        contactManager.addContactWith(contact: contact)
        contact.givenName = testGivenName
        contactManager.updateContact(updatedContact: contact)
        XCTAssertTrue(contactManager.allContactResults.count > 0)
        XCTAssertEqual(contactManager.allContactResults.first?.givenName, testGivenName)
    }
    
    func testContactResultChangeWhenUpdatePhoneNumber() {
        let testPhoneNumber  = [CNLabeledValue(
            label: CNLabelPhoneNumberiPhone,
            value: CNPhoneNumber(stringValue: "87654321"))]
        let contact = dummyContact()
        contactManager.addContactWith(contact: contact)
        contact.phoneNumbers = testPhoneNumber
        contactManager.updateContact(updatedContact: contact)
        XCTAssertTrue(contactManager.allContactResults.count > 0)
        XCTAssertEqual(contactManager.allContactResults.first?.phoneNumbers, testPhoneNumber)
    }
    
}
