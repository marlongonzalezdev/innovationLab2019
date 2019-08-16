import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import * as Material from '@angular/material';

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    Material.MatSelectModule,
    Material.MatButtonModule,
    Material.MatProgressSpinnerModule,
    Material.MatIconModule,
    Material.MatCardModule,
    Material.MatInputModule,
    Material.MatListModule,
    Material.MatSidenavModule,
    Material.MatToolbarModule,
    Material.MatTableModule,
    Material.MatPaginatorModule,
    Material.MatMenuModule,
    Material.MatGridListModule,
    Material.MatRadioModule,
    Material.MatCheckboxModule
  ],
  exports: [
    Material.MatSelectModule,
    Material.MatButtonModule,
    Material.MatProgressSpinnerModule,
    Material.MatIconModule,
    Material.MatCardModule,
    Material.MatInputModule,
    Material.MatListModule,
    Material.MatSidenavModule,
    Material.MatToolbarModule,
    Material.MatTableModule,
    Material.MatPaginatorModule,
    Material.MatMenuModule,
    Material.MatGridListModule,
    Material.MatRadioModule,
    Material.MatCheckboxModule
  ]
})
export class MaterialModule { }
