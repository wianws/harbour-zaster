/*
    Copyright (C) 2018 Sebastian J. Wolf

    This file is part of Zaster Banker.

    Zaster Banker is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Zaster Banker is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Zaster Banker. If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef SEGMENT_H
#define SEGMENT_H

#include "fintselement.h"
#include "dataelementgroup.h"
#include "dataelement.h"
#include <QList>

class Segment : public FinTsElement
{
    Q_OBJECT
public:
    explicit Segment(FinTsElement *parent = 0);
    ~Segment();
    void setHeader(DataElementGroup *newHeader);
    DataElementGroup* getHeader();
    void setDataElements(const QList<DataElement *> &newDataElements);
    QList<DataElement *> getDataElements();
    void addDataElement(DataElement *dataElement);
    void replaceDataElement(int index, DataElement *dataElement);
    int getCompleteLength();
    QString getIdentifier();

signals:
    void headerChanged(DataElementGroup *newHeader);
    void dataElementsChanged(const QList<DataElement *> &newDataElements);

public slots:

private:
    DataElementGroup *header;
    QList<DataElement *> dataElements;

};

#endif // SEGMENT_H
