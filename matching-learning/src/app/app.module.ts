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

import { CandidatesComponent } from './components/candidates/candidates.component';
import { CandidateComponent } from './components/candidates/candidate/candidate.component';
import {CandidateService} from './shared/candidate.service';

import {MaterialModule} from './material/material.module';





@NgModule({
  declarations: [
    AppComponent,
    MatchesComponent,
    UserDetailsComponent,
    SkillsComponent,
    MenuComponent,
    CandidatesComponent,
    CandidateComponent
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
    CandidateService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
