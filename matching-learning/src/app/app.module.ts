import { InputCriteriaComponent } from './components/input-criteria/input-criteria.component';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms'; // <-- NgModel lives here
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MatchesComponent } from './components/matches/matches.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { UserDetailsComponent } from './components/user-details/user-details.component';
import { SkillsComponent } from './components/skills/skills.component';
import { MenuComponent } from './components/menu/menu.component';

import {MatSelectModule, MatButtonModule, MatProgressSpinnerModule, MatIconModule, MatCardModule, MatInputModule} from '@angular/material';
import {MatListModule, MatSidenavModule, MatToolbarModule, MatTableModule, MatPaginatorModule, MatMenuModule} from '@angular/material';

import { HttpErrorHandler } from './http-error-handler.service';
import {MessageService} from '../message.service';
import { SkillServiceBase } from './components/skills/services/skill-servie-base';
import { SkillService } from './components/skills/services/skill.service';
import { SkilldetailsComponent } from './components/skilldetails/skilldetails.component';



@NgModule({
  declarations: [
    AppComponent,
    MatchesComponent,
    UserDetailsComponent,
    SkillsComponent,
    MenuComponent,
    InputCriteriaComponent,
    SkilldetailsComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatSelectModule,
    MatButtonModule,
    HttpClientModule,
    MatProgressSpinnerModule,
    MatIconModule,
    MatCardModule,
    MatInputModule,
    MatTableModule,
    MatPaginatorModule,
    MatSidenavModule,
    MatToolbarModule,
    MatListModule,
    MatMenuModule
  ],
  providers: [
    HttpErrorHandler,
    MessageService,
    { provide: SkillServiceBase, useClass: SkillService }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
