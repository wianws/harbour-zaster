/*
    Copyright (C) 2018 Sebastian J. Wolf

    This file is part of ZasterBanker.

    ZasterBanker is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ZasterBanker is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ZasterBanker. If not, see <http://www.gnu.org/licenses/>.
*/

#include "zaster.h"

Zaster::Zaster(QObject *parent) : QObject(parent), settings("harbour-zaster", "settings")
{
    this->networkAccessManager = new QNetworkAccessManager(this);
    wagnis = new Wagnis(this->networkAccessManager, "harbour-zaster", "0.1", this);
    finTsDialog = new FinTsDialog(this, this->networkAccessManager);
    finTsBalances = new FinTsBalances(this, finTsDialog);
}

Zaster::~Zaster()
{
}

Wagnis *Zaster::getWagnis()
{
    return this->wagnis;
}

FinTsDialog *Zaster::getFinTsDialog()
{
    return this->finTsDialog;
}

FinTsBalances *Zaster::getFinTsBalances()
{
    return this->finTsBalances;
}
