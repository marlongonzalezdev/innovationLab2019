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
import { EvaluationListComponent } from './components/evaluations/evaluation-list/evaluation-list.component';
import { EvaluationComponent } from './components/evaluations/evaluation/evaluation.component';
import { EvaluationService } from './shared/services/evaluation.service';
import { DeliveryUnitComponent } from './components/delivery-units/delivery-unit/delivery-unit.component';
import { DeliveryUnitListComponent } from './components/delivery-units/delivery-unit-list/delivery-unit-list.component';
import { DeliveryUnitsComponent } from './components/delivery-units/delivery-units.component';
import { RegionComponent } from './components/regions/region/region.component';
import { RegionListComponent } from './components/regions/region-list/region-list.component';
import { RegionsComponent } from './components/regions/regions.component';
import {FlexLayoutModule} from '@angular/flex-layout';
import { PageNotFoundComponent } from './components/page-not-found/page-not-found.component';
import { LoginComponent } from './components/login/login.component';


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
    CandidateListComponent,
    SkilldetailsComponent,
    EvaluationListComponent,
    EvaluationComponent,
    DeliveryUnitComponent,
    DeliveryUnitsComponent,
    DeliveryUnitListComponent,
    RegionComponent,
    RegionsComponent,
    RegionListComponent,
    PageNotFoundComponent,
    LoginComponent,

  ],
  imports: [
    BrowserModule,
    FormsModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MaterialModule,
    ReactiveFormsModule,
    FlexLayoutModule
  ],
  providers: [
    HttpErrorHandler,
    MessageService,
    { provide: SkillServiceBase, useClass: SkillService },
    CandidateService,
    DeliveryUnitService,
    RelationTypeService,
    NotificationService,
    EvaluationService
  ],
  bootstrap: [AppComponent],
  entryComponents: [CandidateComponent, UserDetailsComponent, SkilldetailsComponent]
})
export class AppModule { }
