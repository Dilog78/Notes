class Contacts extends StatelessWidget {

  Contacts() {
    contactsModel.loadData('contacts', ContactsDBWorker.db);
  }

  Widget build(BuildContext inContext) {

    return ScopedModel<ContactsModel>(
        model : contactsModel,
        child : ScopedModelDescendant<ContactsModel>(
            builder : (BuildContext inContext, Widget inChild, ContactsModel inModel) {
              return IndexedStack(
                  index : inModel.stackIndex,
                  children : [
                    ContactsList(),
                    ContactsEntry()
                  ]
              );
            }
        )
    );
  }
}