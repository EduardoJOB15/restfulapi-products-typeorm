import {Entity, Column, PrimaryColumn} from "typeorm";

@Entity({schema:"example", database:"ingresos", name:"fact_summary"})
export class fact_summary{
    @Column()
    CustomerID: number;

    @Column()
    SupplierID: number;

    @Column()
    SupplierName: string;

    @Column()
    mes: number;

    @Column()
    year: number;

    @Column()
    total: number;

    @Column()
    SuperoPromedio: string;

    @Column()
    PorcentajeVentaMensual : number;
}

export interface ISummary{
    CustomerID : number
}

export interface IResult{
    Successed: boolean;
    MSG: string
}