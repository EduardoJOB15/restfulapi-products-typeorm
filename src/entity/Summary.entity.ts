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
    mes: string;

    @Column()
    yea: string;

    @Column()
    total: number;

    @Column()
    SuperoPromedio: string;

    @Column()
    PorcentajeVentaMensual : number;
}


export interface IResult{
    Successed: boolean;
    MSG: string
}