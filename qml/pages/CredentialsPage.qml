/*
    Copyright (C) 2018 Sebastian J. Wolf

    This file is part of Zaster.

    Zaster is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Zaster is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Zaster. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: credentialsPage
    allowedOrientations: Orientation.All

    Component.onCompleted: {
        finTsDialog.dialogInitialization();
        loadingColumn.visible = true;
    }

    Connections {
        target: finTsDialog
        onDialogInitializationCompleted: {
            loadingColumn.visible = false;
            if (finTsDialog.supportsPinTan()) {
                finTsDialog.closeDialog();
                credentialsColumn.visible = true;
            } else {
               errorColumn.retryPossible = false;
               errorColumn.visible = true;
               errorInfoLabel.text = qsTr("Your bank doesn't seem to support FinTS PIN/TAN. Please contact your bank for assistance!");
            }
        }
        onDialogInitializationFailed: {
            loadingColumn.visible = false;
            errorColumn.retryPossible = true;
            errorColumn.visible = true;
            errorInfoLabel.text = qsTr("Unable to connect to your bank. Please ensure that your internet connection works properly and try again.");
        }
        onDialogEndCompleted: {
            console.log("Anonymous dialog successfully terminated.");
        }
        onDialogEndFailed: {
            console.log("Error terminating anonymous dialog.");
        }
    }

    SilicaFlickable {

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: credentialsColumn.visible ? credentialsColumn.height : parent.height

        Column {
            id: loadingColumn
            width: parent.width
            height: loadingLabel.height + loadingBusyIndicator.height + Theme.paddingMedium
            spacing: Theme.paddingMedium
            anchors.verticalCenter: parent.verticalCenter

            Behavior on opacity { NumberAnimation {} }
            opacity: visible ? 1 : 0
            visible: false

            InfoLabel {
                id: loadingLabel
                text: qsTr("Saying hello to your bank...")
            }

            BusyIndicator {
                id: loadingBusyIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                running: loadingColumn.visible
                size: BusyIndicatorSize.Large
            }
        }

        Column {

            property bool retryPossible: false

            id: errorColumn
            height: errorInfoLabel.height + zasterErrorImage.height + errorOkButton.height + ( 3 * Theme.paddingMedium )
            width: parent.width
            spacing: Theme.paddingMedium
            anchors.verticalCenter: parent.verticalCenter

            Behavior on opacity { NumberAnimation {} }
            opacity: visible ? 1 : 0
            visible: false

            Image {
                id: zasterErrorImage
                source: "../../images/zaster.svg"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                fillMode: Image.PreserveAspectFit
                width: 1/2 * parent.width
            }

            InfoLabel {
                id: errorInfoLabel
                font.pixelSize: Theme.fontSizeLarge
                text: ""
            }

            Button {
                id: errorOkButton
                text: qsTr("OK")
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                onClicked: {

                    if (errorColumn.retryPossible) {
                        errorColumn.visible = false;
                        finTsDialog.dialogInitialization();
                        loadingColumn.visible = true;
                    } else {
                        errorColumn.visible = false;
                        pageStack.pop();
                    }

                }
            }
        }

        Column {
            id: credentialsColumn
            width: parent.width
            spacing: Theme.paddingMedium

            Behavior on opacity { NumberAnimation {} }
            opacity: visible ? 1 : 0
            visible: false

            PageHeader {
                id: searchHeader
                title: qsTr("Enter your Credentials")
            }

            SectionHeader {
                text: qsTr("Your Bank")
            }

            DetailItem {
                label: qsTr("Name")
                value: finTsDialog.getBankName()
            }

            DetailItem {
                label: qsTr("Bank ID")
                value: finTsDialog.getBankId()
            }

            SectionHeader {
                text: qsTr("Your Credentials")
            }

            TextField {
                id: userNameField
                width: parent.width
                placeholderText: qsTr("User name")
                labelVisible: false
            }

            PasswordField {
                id: pinField
                width: parent.width
                placeholderText: qsTr("PIN or Password")
                labelVisible: false
            }

            Button {
                id: loginButton
                text: qsTr("Login")
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                enabled: ( userNameField.text !== "" && pinField.text !== "" )
                onClicked: {
                    finTsDialog.setUserData(userNameField.text, pinField.text);
                    pageStack.clear();
                    pageStack.push(Qt.resolvedUrl("OverviewPage.qml"));
                }
            }

            Label {
                id: separatorLabel
                width: parent.width
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }


        }

    }

}