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



@NgModule({
  declarations: [
    AppComponent,
    MatchesComponent,
    UserDetailsComponent,
    SkillsComponent,
    MenuComponent
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
    MessageService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
