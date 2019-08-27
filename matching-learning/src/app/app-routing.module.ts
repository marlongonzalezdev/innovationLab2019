import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { SkillsComponent } from './components/skills/skills.component';
import { CandidatesComponent } from './components/candidates/candidates.component';
import { InputCriteriaComponent } from './components/input-criteria/input-criteria.component';
import { DeliveryUnitsComponent } from './components/delivery-units/delivery-units.component';
import { RegionsComponent } from './components/regions/regions.component';
import {EvaluationsComponent} from './components/evaluations/evaluations.component';

const routes: Routes = [
  {path: 'skills', component: SkillsComponent},
  {path: 'candidates', component: CandidatesComponent},
  {path: 'build', component: InputCriteriaComponent},
  {path: 'dus', component: DeliveryUnitsComponent},
  {path: 'regions', component: RegionsComponent},
  {path: 'evaluations', component: EvaluationsComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
