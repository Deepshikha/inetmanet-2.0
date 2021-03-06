/*
 * Copyright (C) 2006 Isabel Dietrich <isabel.dietrich@informatik.uni-erlangen.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */


#include "LinealNodeDistributionMobility.h"


Define_Module(LinealNodeDistributionMobility);


LinealNodeDistributionMobility::LinealNodeDistributionMobility()
{
    initialX = 0;
    initialY = 0;
    separation = 0;
    orientation = 0;
}

void LinealNodeDistributionMobility::initialize(int stage)
{
    MobilityBase::initialize(stage);
    EV << "initializing StaticGridMobility stage " << stage << endl;
    if (stage == 0)
    {
        initialX = par("initialX").doubleValue();
        initialY = par("initialY").doubleValue();
        separation = par("separation").doubleValue();
        orientation = par("orientation").doubleValue();
    }
}

void LinealNodeDistributionMobility::initializePosition()
{
    int index = visualRepresentation->getIndex();
    double rad = PI * orientation / 180.0;
    Coord initialPos;
    initialPos.x = initialX;
    initialPos.y = initialY;
    initialPos.z = 0;
    Coord direction(cos(rad), sin(rad));
    lastPosition = initialPos + (direction * (index * separation));
    if (lastPosition.x >= constraintAreaMax.x)
        lastPosition.x -= 1;
    if (lastPosition.y >= constraintAreaMax.y)
        lastPosition.y -= 1;
    lastPosition.z = 0;
}

void LinealNodeDistributionMobility::finish()
{
    MobilityBase::finish();
    recordScalar("x", lastPosition.x);
    recordScalar("y", lastPosition.y);
}
