import { SkillService } from './shared/services/skill.service';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import {FormsModule, ReactiveFormsModule} from '@angular/forms'; // <-- NgModel lives here
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MatchesComponent } from './components/matches/matches.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { UserDetailsComponent } from './components/user-details/user-details.component';
import { SkillsComponent } from './components/skills/skills.component';
import { MenuComponent } from './components/menu/menu.component';

import { HttpErrorHandler } from './http-error-handler.service';
import {MessageService} from '../message.service';

import { SkilldetailsComponent } from './components/skilldetails/skilldetails.component';

import { CandidatesComponent } from './components/candidates/candidates.component';
import { CandidateComponent } from './components/candidates/candidate/candidate.component';


import {MaterialModule} from './material/material.module';
import { RelationTypeService } from './shared/services/relation-type.service';
import { CandidateService } from './shared/services/candidate.service';
import { DeliveryUnitService } from './shared/services/delivery-unit.service';
import { NotificationService } from './shared/services/notification.service';
import { CandidateListComponent } from './components/candidates/candidate-list/candidate-list.component';
import { SkillServiceBase } from './shared/services/skill-service-base';
import { InputCriteriaComponent } from './components/input-criteria/input-criteria.component';




@NgModule({
  declarations: [
    AppComponent,
    MatchesComponent,
    UserDetailsComponent,
    SkillsComponent,
    MenuComponent,
    InputCriteriaComponent,
    CandidatesComponent,
    SkilldetailsComponent,
    CandidateComponent,
    CandidateListComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MaterialModule,
    ReactiveFormsModule
  ],
  providers: [
    HttpErrorHandler,
    MessageService,
    { provide: SkillServiceBase, useClass: SkillService },
    CandidateService,
    DeliveryUnitService,
    RelationTypeService,
    NotificationService
  ],
  bootstrap: [AppComponent],
  entryComponents: [CandidateComponent]
})
export class AppModule { }
