import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {SkillsComponent} from './components/skills/skills.component';
import {CandidatesComponent} from './components/candidates/candidates.component';

const routes: Routes = [
  {path: 'skills', component: SkillsComponent},
  {path: 'candidates', component: CandidatesComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
