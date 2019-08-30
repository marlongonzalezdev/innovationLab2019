import { AuthGuard } from './shared/auth.guard';
import { LoginComponent } from './components/login/login.component';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { SkillsComponent } from './components/skills/skills.component';
import { CandidatesComponent } from './components/candidates/candidates.component';
import { InputCriteriaComponent } from './components/input-criteria/input-criteria.component';
import { DeliveryUnitsComponent } from './components/delivery-units/delivery-units.component';
import { RegionsComponent } from './components/regions/regions.component';

import {PageNotFoundComponent} from './components/page-not-found/page-not-found.component';
import {EvaluationListComponent} from './components/evaluations/evaluation-list/evaluation-list.component';

const routes: Routes = [
  // { path: '**', component: PageNotFoundComponent },
  {path: 'skills', component: SkillsComponent},
  {path: 'candidates', component: CandidatesComponent},
  {path: 'build', component: InputCriteriaComponent, canActivate: [AuthGuard]},
  {path: 'dus', component: DeliveryUnitsComponent},
  {path: 'regions', component: RegionsComponent},
  {path: 'evaluations/:id', component: EvaluationListComponent},
  { path: 'login', component: LoginComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
